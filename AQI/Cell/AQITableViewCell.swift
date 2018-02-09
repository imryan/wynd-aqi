//
//  AQITableViewCell.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit

class AQITableViewCell: UITableViewCell {
    
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var concernLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: Setup
    
    public func setupWithAQI(_ aqi: AQI) {
        setupUI()
        
        self.backgroundColor = aqi.color
        
        // Historic log
        if let index = aqi.index, let timestamp = aqi.timestamp {
            aqiLabel.text = String(index)
            timestampLabel.text = String.prettyDateString(date: timestamp, full: true)
            timestampLabel.isHidden = false
        } else {
            aqiLabel.text = aqi.rangeString
            timestampLabel.isHidden = true
        }
        
        concernLabel.text = aqi.concern.uppercased()
        meaningLabel.text = aqi.meaning
    }
    
    // MARK: UI
    
    func setupUI() {
        aqiLabel.textColor = UIColor.white
        aqiLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        
        concernLabel.textColor = UIColor.withAlphaComponent(.white)(0.8)
        concernLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        concernLabel.minimumScaleFactor = 12
        
        meaningLabel.textColor = UIColor.white
        meaningLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        meaningLabel.numberOfLines = 0
        
        timestampLabel.textColor = UIColor.white
        timestampLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
