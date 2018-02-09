//
//  Station.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import Foundation
import CoreLocation

struct Station : Codable {
    
    let aqi: Int?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    
    private enum CodingKeys: CodingKey {
        case aqi
        case latitude
        case longitude
    }
}

extension Station {
    
    var coordinate: CLLocationCoordinate2D {
        if let latitude = latitude, let longitude = longitude {
            if (latitude <= 90 && latitude >= -90) && (longitude <= 180 && longitude >= -180) {
                return CLLocationCoordinate2DMake(latitude, longitude)
            }
        }
        
        return CLLocationCoordinate2DMake(0, 0)
    }
    
    var resultAQI: AQI? {
        if let index = aqi {
            return AQI.levelForIndex(index)
        }
        
        return nil
    }
}
