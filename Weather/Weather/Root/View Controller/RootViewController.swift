//
//  RootViewController.swift
//  Weather
//
//  Created by Payal Singh on 13/08/21.
//

import UIKit
import CoreLocation
import CoreData
import Combine

class RootViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    weak var delegate:LocationSelectedDelegate?
    private var subscriptions: Set<AnyCancellable> = []

    let dataManager = DataManager() //Manages Network Request to API
    let locationViewModel = LocationViewModel(locationService: LocationService())
    
    @IBOutlet var searchBar:UISearchBar!

    lazy var activityIndicatorView:UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        tableView.backgroundView = activityIndicatorView
        return activityIndicatorView
    }()
    
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
            locationViewModel.coordinate = coordinate
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
        self.searchBar.resignFirstResponder()
        self.requestLocation()
        setupLocationViewModel()
    }
    
    func setupLocationViewModel(){
        // Subscribe to Locations Publisher
        locationViewModel.locationsPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.setContentOffset(.zero, animated: true)
                self?.tableView.reloadData()
            }).store(in: &subscriptions)
        
        // Subscribe to Querying
        locationViewModel.$querying
            .sink(receiveValue: { [weak self] (isQuerying) in
                if isQuerying {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }).store(in: &subscriptions)
    }
    
//    func updateView(){
//        loadViewIfNeeded()
//        activityIndicatorView.stopAnimating()
//        self.tableView.setContentOffset(.zero, animated: true)
//        self.tableView.reloadData()
//    }
        
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

extension RootViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationViewModel.locationCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }
        
        let locationRowViewModel = locationViewModel.viewModel(for: indexPath.row)
        cell.locationID.text = locationRowViewModel.locationId
        cell.locationType.text = locationRowViewModel.locationType
        cell.locationTitle.text = locationRowViewModel.locationTitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locationViewModel.viewModel(for: indexPath.row)
        let locationID = location.locationId
        delegate?.locationSelected(locationID)
        updateRecentSearches(location.locationTitle)

        if let detailViewController = delegate as? WeatherDetailViewController,
          let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    @IBAction func unwindFromRecents(sender: UIStoryboardSegue) {
        if sender.source is RecentsViewController {
            if let dataReceived = (sender.source as! RecentsViewController).dataPassed{
                searchBar.text = dataReceived
                locationViewModel.query = dataReceived
                updateRecentSearches(dataReceived)
            }
        }
    }
    
    func updateRecentSearches(_ locationTitle:String?){
        if let locationTitle = locationTitle, !locationTitle.isEmpty{
            searchBar.resignFirstResponder()
            dataManager.addorUpdateRecentSearch(locationTitle, managedObjectContext)
        }
    }
}


extension RootViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update Query
        locationViewModel.query = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Update Query
        locationViewModel.query = searchBar.text ?? ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        // Update Query
        updateRecentSearches(searchBar.text)
        locationViewModel.query = searchBar.text ?? ""
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide Keyboard
        searchBar.resignFirstResponder()
        // Reset Query
        locationViewModel.query = ""
    }
}
