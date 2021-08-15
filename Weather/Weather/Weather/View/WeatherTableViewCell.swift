//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var averageTemperatureLabel:UILabel!
    @IBOutlet var temperatureRangeLabel:UILabel!
    @IBOutlet var humidityLabel:UILabel!
    @IBOutlet var airPressureLabel:UILabel!
    @IBOutlet var visibilityLabel:UILabel!
    @IBOutlet var windLabel:UILabel!
    @IBOutlet var weatherLabel:UILabel!
    @IBOutlet var weatherImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        dayLabel.text = ""
        dateLabel.text = ""
        averageTemperatureLabel.text = ""
        temperatureRangeLabel.text = ""
        weatherLabel.text = ""
        humidityLabel.text = ""
        airPressureLabel.text = ""
        visibilityLabel.text = ""
        windLabel.text = ""
        weatherImageView?.isHidden = true

    }

}
