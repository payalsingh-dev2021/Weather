//
//  RecentsTableViewCell.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import UIKit

class RecentsTableViewCell: UITableViewCell {

    @IBOutlet var searchText:UILabel!
    @IBOutlet var searchTimestamp:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
