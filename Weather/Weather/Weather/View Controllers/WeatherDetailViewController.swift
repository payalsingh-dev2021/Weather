//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import UIKit

class WeatherDetailViewController: UITableViewController {
    let dataManager = DataManager() //Manages Network Request to API
    var locationID:String?{
        didSet{
            if let locationID = locationID{
                loadViewIfNeeded()
                fetchLocationsWeatherData(forID: locationID)
            }
        }
    }
    
    var locationWeatherDataViewModel: LocationWeatherDataViewModel? {
        didSet {
            updateView()
        }
    }
    var activityIndicatorView:UIActivityIndicatorView!

    func updateView(){
        activityIndicatorView.stopAnimating()
        self.title = locationWeatherDataViewModel?.locationTitle
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
    }
    
    func fetchLocationsWeatherData(forID locationID:String){
        self.activityIndicatorView.startAnimating()
        dataManager.fetchWeatherData(by: SearchType.EarthID(locationID), responseType: LocationWeatherData.self){ [weak self](result) in
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let locationWeatherData):
                print("success",locationWeatherData)
                self?.locationWeatherDataViewModel = LocationWeatherDataViewModel(locationWeatherData: locationWeatherData)
            case .failure:
                // Notify User
                self?.presentAlert(with: "Unable to Fetch Weather Data for this Location",
                                   and: "Some error occured while fetching data")
            }
        }
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

extension WeatherDetailViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationWeatherDataViewModel?.daysCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeatherTableViewCell else {
            fatalError("Unable to Dequeue Weather Detail Table View Cell")
        }

        guard let locationWeatherDataViewModel = locationWeatherDataViewModel else{
            fatalError("Unable to Dequeue Weather Detail Table View Cell")
        }

        let locationWeatherDataRowViewModel = locationWeatherDataViewModel.viewModel(for: indexPath.row)
        
        cell.dayLabel.text = locationWeatherDataRowViewModel.day
        cell.dateLabel.text = locationWeatherDataRowViewModel.date
        cell.averageTemperatureLabel.text = locationWeatherDataRowViewModel.averageTemperature
        cell.temperatureRangeLabel.text = locationWeatherDataRowViewModel.temperatureRange
        cell.weatherLabel.text = locationWeatherDataRowViewModel.weather
        cell.humidityLabel.text = locationWeatherDataRowViewModel.humidity
        cell.airPressureLabel.text = locationWeatherDataRowViewModel.airPressure
        cell.visibilityLabel.text = locationWeatherDataRowViewModel.visibility
        cell.windLabel.text = locationWeatherDataRowViewModel.wind
        cell.weatherImageView?.image = UIImage(named: locationWeatherDataRowViewModel.imageName)
        cell.weatherImageView?.isHidden = false

        return cell
    }
    
    
}
