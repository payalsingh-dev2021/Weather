//
//  RootViewController.swift
//  Weather
//
//  Created by Payal Singh on 13/08/21.
//

import UIKit
import CoreLocation
import CoreData

class RootViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    @IBOutlet var searchBar:UISearchBar!
    
    let dataManager = DataManager() //Manages Network Request to API
    var locationViewModel: LocationViewModel? {
        didSet {
            updateView()
        }
    }
    
    var activityIndicatorView:UIActivityIndicatorView!
    private enum AlertType {
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailable
    }
    
    //Based on Location Permissions - whenever currentLocation is updated
    //start fetching locations
    private var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = currentLocation else {
                print("No coordinates to fetch location")
                return
            }
            let coordinate = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
            fetchLocationsByCoordinate(coordinate)
        }
    }
        
    private lazy var locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()

        // Configure Location Manager
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0

        return locationManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        tableView.reloadData()
        self.requestLocation()
    }
    
    
    func updateView(){
        activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
    }
        
    private func requestLocation() {
        // Configure Location Manager
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Request Current Location
            locationManager.requestLocation()
        default:
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
    // MARK: -
    
    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String
        
        switch alertType {
        case .notAuthorizedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Weather is not authorized to access your current location. You can grant Weather access to your current location in the Settings application."
        case .failedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Weather is not able to fetch your current location due to a technical issue."
        case .noWeatherDataAvailable:
            title = "Unable to Fetch Weather Data"
            message = "Weather is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
        }
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        present(alertController, animated: true)
    }
    
    
    func presentAlert(with title:String,and message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add Cancel Action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        present(alertController, animated: true)
    }
}


extension RootViewController: CLLocationManagerDelegate {
    // MARK: - Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            // Request Location
            manager.requestLocation()
        case .denied,
             .restricted:
            // Notify User
            presentAlert(of: .notAuthorizedToRequestLocation)
        default:
            print("Fetch weather for searched Location - default")
        }
    }

    // MARK: - Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update Current Location
            currentLocation = location

            // Reset Delegate
            manager.delegate = nil

            // Stop Location Manager
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Notify User
        presentAlert(of: .failedToRequestLocation)
    }
}

//extension RootViewController: LocationsViewControllerDelegate {
//
//    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
//        currentLocation = location
//    }
//
//}

extension RootViewController{
            
        func fetchLocationsByCoordinate(_ coordinate:String){
            activityIndicatorView.startAnimating()
            dataManager.fetchWeatherData(by: SearchType.Coordinate(coordinate), responseType: [Location].self){ [weak self](result) in
                self?.activityIndicatorView.stopAnimating()
                switch result {
                case .success(let locationData):
                    print("success",locationData)
                    self?.locationViewModel = LocationViewModel(locations: locationData)
                case .failure:
                    // Notify User
                    self?.presentAlert(with: "Unable to Fetch Weather Data for Your Location", and: "Some error occured while fetching data")
                }
            }
        }
        
        func fetchLocationsByQuery(_ searchQuery:String){
            activityIndicatorView.startAnimating()
            dataManager.fetchWeatherData(by: SearchType.Location(searchQuery), responseType: [Location].self){[weak self](result) in
                self?.activityIndicatorView.stopAnimating()
                switch result {
                case .success(let locationData):
                    self?.locationViewModel = LocationViewModel(locations: locationData)
                case .failure:
                    // Notify User
                    self?.presentAlert(with: "Unable to Fetch Weather Data", and: "Some error occured while fetching data")
                }
            }
        }
        

}


extension RootViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModel?.locationCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }

        guard let locationViewModel = locationViewModel else{
            fatalError("Unable to Dequeue Location Table View Cell")
        }
        
        let locationRowViewModel = locationViewModel.viewModel(for: indexPath.row)
        cell.locationID.text = locationRowViewModel.locationId
        cell.locationType.text = locationRowViewModel.locationType
        cell.locationTitle.text = locationRowViewModel.locationTitle

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailViewController,
           let selectedRow = tableView.indexPathForSelectedRow?.row{
            destination.locationID = locationViewModel?.viewModel(for: selectedRow).locationId
        }
    }
    
    @IBAction func unwindFromRecents(sender: UIStoryboardSegue) {
        if sender.source is RecentsViewController {
            if let dataReceived = (sender.source as! RecentsViewController).dataPassed{
                searchBar.text = dataReceived
                fetchLocationsByQuery(dataReceived)
                dataManager.addorUpdateRecentSearch(dataReceived, managedObjectContext)
            }
        }
    }

    
    
}


extension RootViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            fetchLocationsByQuery(searchText)
            dataManager.addorUpdateRecentSearch(searchText, managedObjectContext)
        }
    }
}
