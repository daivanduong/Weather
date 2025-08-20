//
//  WeatherVCTableViewCell.swift
//  Weather
//
//  Created by Đại Dương on 20/08/2025.
//

import UIKit

class WeatherVCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbCityName: UILabel!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lbTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
