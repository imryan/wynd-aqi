//
//  Extensions.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func aqiGreen() -> UIColor {
        return UIColor.init(red: 41/255, green: 197/255, blue: 102/255, alpha: 1.0)
    }
    
    class func aqiYellow() -> UIColor {
        return UIColor.init(red: 255/255, green: 198/255, blue: 8/255, alpha: 1.0)
    }
    
    class func aqiOrange() -> UIColor {
        return UIColor.init(red: 226/255, green: 114/255, blue: 31/255, alpha: 1.0)
    }
    
    class func aqiRed() -> UIColor {
        return UIColor.init(red: 228/255, green: 66/255, blue: 53/255, alpha: 1.0)
    }
    
    class func aqiPurple() -> UIColor {
        return UIColor.init(red: 144/255, green: 79/255, blue: 173/255, alpha: 1.0)
    }
    
    class func aqiBrown() -> UIColor {
        return UIColor.init(red: 110/255, green: 42/255, blue: 37/255, alpha: 1.0)
    }
}

extension String {
    
    static func prettyDateString(date: Date, full: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = (full) ? "YYYY-MM-dd h:mm:ss a" : "h:mm a"
        
        return formatter.string(from: date)
    }
}

