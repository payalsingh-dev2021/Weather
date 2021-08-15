//
//  LocationTableViewCell.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet var locationTitle:UILabel!
    @IBOutlet var locationType:UILabel!
    @IBOutlet var locationID:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
