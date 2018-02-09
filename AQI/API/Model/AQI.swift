//
//  AQI.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit

class AQI {
    
    /// Current index
    var index: Int?
    
    /// Current timestamp
    var timestamp: Date?
    
    /// AQI range (e.g. 0-50)
    var range: Range<Int>!
    
    /// AQI Range string (e.g. '0-50')
    var rangeString: String {
        return "\(range.lowerBound)-\(range.upperBound)"
    }
    
    /// Concern level (e.g. 'Good')
    var concern: String!
    
    /// Meaning of AQI
    var meaning: String!
    
    /// Color code for AQI
    var color: UIColor!
    
    // MARK: Initialization
    
    /// Initialization
    ///
    /// - Parameters:
    ///   - range: AQI value range
    ///   - concern: Health concern level
    ///   - meaning: Meaning of air quality
    ///   - color: Corresponding color for AQI tier
    private init(range: Range<Int>, concern: String, meaning: String, color: UIColor) {
        self.range = range
        self.concern = concern
        self.meaning = meaning
        self.color = color
    }
    
    // MARK: Functions
    
    /// Fetch AQI tier for the given index
    ///
    /// - Parameter index: Current index
    /// - Returns: AQI tier for the given index
    class func levelForIndex(_ index: Int) -> AQI? {
        for level in allLevels() {
            if level.range.contains(index) {
                level.index = index
                level.timestamp = Date()
                return level
            }
        }
        
        return nil
    }
}

extension AQI {
    
    /// Fetch all AQI tiers
    ///
    /// - Returns: All AQI tiers
    class func allLevels() -> [AQI] {
        let good = AQI(range: 0..<50,
                       concern: "Good",
                       meaning: "Air quality is considered satisfactory, and air pollution poses little or no risk.",
                       color: UIColor.aqiGreen())
        
        let moderate = AQI(range: 51..<100,
                           concern: "Moderate",
                           meaning: "Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.",
                           color: UIColor.aqiYellow())
        
        let unhealthySensitive = AQI(range: 101..<150,
                                     concern: "Unhealthy for Sensitive Groups",
                                     meaning: "Members of sensitive groups may experience health effects. The general public is not likely to be affected.",
                                     color: UIColor.aqiOrange())
        
        let unhealthy = AQI(range: 151..<200,
                            concern: "Unhealthy",
                            meaning: "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects.",
                            color: UIColor.aqiRed())
        
        let veryUnhealthy = AQI(range: 201..<300,
                                concern: "Very Unhealthy",
                                meaning: "Health alert: everyone may experience more serious health effects.",
                                color: UIColor.aqiPurple())
        
        let hazardous = AQI(range: 301..<500,
                            concern: "Hazardous",
                            meaning: "Health warnings of emergency conditions. The entire population is more likely to be affected.",
                            color: UIColor.aqiBrown())
        
        return [good, moderate, unhealthySensitive, unhealthy, veryUnhealthy, hazardous]
    }
}
