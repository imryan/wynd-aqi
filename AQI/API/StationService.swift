//
//  StationService.swift
//  AQI
//
//  Created by Ryan Cohen on 2/1/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import Foundation
import CoreLocation

protocol StationProtocol {
    /// Fetched nearest Station and AQI
    ///
    /// - Parameter station: Last updated Station object returned
    func didFetchNearestStation(_ station: Station?)
}

class StationService {
    
    /// Singleton instance
    static let shared = StationService()
    
    /// Delegate to notify on Station updates
    var delegate: StationProtocol?
    
    /// All recorded AQIs
    var aqiLogs: [AQI] = []
    
    /// Fetch nearest station to given coordinates
    ///
    /// - Parameters:
    ///   - coordinates: Coordinates of user's location
    func fetchNearestStation(to coordinates: CLLocationCoordinate2D) {
        URLSession.shared.dataTask(with: endpoint(coordinate: coordinates)) { (data, response, error) in
            do {
                let station = try JSONDecoder().decode(Station.self, from: data!)
                if let aqi = station.resultAQI {
                    if !self.aqiLogs.contains(where: { $0.index == aqi.index })  {
                        self.aqiLogs.append(aqi)
                    }
                    
                    self.delegate?.didFetchNearestStation(station)
                }
            } catch {
                print("Error fetching station.")
                self.delegate?.didFetchNearestStation(nil)
            }
        }.resume()
    }
}

extension StationService {
    
    private func endpoint(coordinate: CLLocationCoordinate2D) -> URL {
        let endpoint = "\(Secrets.BASE_URL)?lat=\(coordinate.latitude)&lng=\(coordinate.longitude)"
        return URL(string: endpoint)!
    }
}
