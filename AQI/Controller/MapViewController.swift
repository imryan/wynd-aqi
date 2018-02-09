//
//  MapViewController.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    
    @IBOutlet weak var helpBarItem: UIBarButtonItem!
    
    lazy var geocoder = CLGeocoder()
    var banner: AQIBanner!
    var mapView: MGLMapView!
    
    // MARK: AQI Functions
    
    func fetchAQIUpdate(withCoordinate coordinate: CLLocationCoordinate2D) {
        StationService.shared.fetchNearestStation(to: coordinate)
    }
    
    @objc func fetchAQIUpdate() {
        if let userLocation = mapView.userLocation {
            if (userLocation.coordinate.latitude == 0.0 && userLocation.coordinate.longitude == 0.0) {
                // Location invalid
            } else {
                StationService.shared.fetchNearestStation(to: userLocation.coordinate)
            }
        }
    }
    
    func beginFetchingAQIUpdates(atInterval interval: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            self.fetchAQIUpdate()
        }
    }
    
    // MARK: Map Functions
    
    func wipeMapOverlays() {
        DispatchQueue.main.async {
            self.mapView.removeOverlays(self.mapView.overlays)
            
            if let annotations = self.mapView.annotations {
                self.mapView.removeAnnotations(annotations)
            }
        }
    }
    
    func addWeatherStationMarker(coordinate: CLLocationCoordinate2D) {
        wipeMapOverlays()
        
        resolveAddress(forCoordinate: coordinate) { (address) in
            let pin = MGLPointAnnotation()
            pin.coordinate = coordinate
            pin.subtitle = address
            
            if let userLocation = self.mapView.userLocation {
                if let location = userLocation.location {
                    let stationLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
                    let distance = location.distance(from: stationLocation)
                    let miles = String(format: "%.2f", (distance / 1609.34))
                    
                    pin.title = "📡 Weather Station (\(miles) mi)"
                }
                
                let line = MGLPolyline(coordinates: [userLocation.coordinate, pin.coordinate], count: 2)
                let bounds = MGLCoordinateBounds(sw: pin.coordinate, ne: userLocation.coordinate)
                let insets = UIEdgeInsetsMake(self.banner.frame.size.height + 100, 50, 50, 50)
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(pin)
                    self.mapView.addOverlays([line])
                    self.mapView.setVisibleCoordinateBounds(bounds, edgePadding: insets, animated: false)
                    self.mapView.selectAnnotation(pin, animated: true)
                }
            }
        }
    }
    
    func resolveAddress(forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> ()) {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) in
            if let placemark = placemarks?.first, error == nil {
                completion("\(placemark.name!) • \(placemark.locality!), \(placemark.administrativeArea!)")
            } else {
                completion(nil)
            }
        }
    }
    
    @objc func addUserMarker(recognizer: UILongPressGestureRecognizer) {
        let pin = MGLPointAnnotation()
        pin.title = "User pin"
        pin.subtitle = "Where is it"
        pin.coordinate = mapView.convert(recognizer.location(in: mapView), toCoordinateFrom: mapView)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(pin)
        }
        
        fetchAQIUpdate(withCoordinate: pin.coordinate)
    }
    
    // MARK: UI
    
    func setupMapbox() {
        mapView = MGLMapView(frame: view.frame)
        mapView.delegate = self
        mapView.allowsRotating = false
        mapView.showsUserLocation = true
        mapView.styleURL = MGLStyle.lightStyleURL()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    func setupHUD() {
        banner = AQIBanner()
        banner.delegate = self
        view.addSubview(banner)
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    func setupGestureRecognizer() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(addUserMarker(recognizer:)))
        recognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(recognizer)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Alter nav bar style
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Receive callbacks from weather service
        StationService.shared.delegate = self
        
        // Setup view
        setupMapbox()
        setupHUD()
        setupGestureRecognizer()
        
        // Update every 3 minutes
        beginFetchingAQIUpdates(atInterval: (3.0 * 60.0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: MGLMapViewDelegate

extension MapViewController : MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        // Refresh every location change in simulator
        // (less frequent updates + fun to swap locations in Xcode)
        if TARGET_IPHONE_SIMULATOR != 0 {
            fetchAQIUpdate()
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if let aqi = StationService.shared.aqiLogs.last {
            return aqi.color
        }
        
        return UIColor.gray
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 2.0
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Load location regularly on actual device
        if TARGET_OS_SIMULATOR != 1 {
            if let userLocation = mapView.userLocation {
                StationService.shared.fetchNearestStation(to: userLocation.coordinate)
            }
        }
    }
}

// MARK: StationProtocol

extension MapViewController : StationProtocol {
    
    func didFetchNearestStation(_ station: Station?) {
        if let station = station {
            addWeatherStationMarker(coordinate: station.coordinate)
            
            if let aqi = station.resultAQI {
                DispatchQueue.main.async {
                    self.banner.updateWithAQI(aqi)
                    self.navigationController?.navigationBar.tintColor = aqi.color
                }
            }
        } else {
            // showAlert(title: "Error", message: "Could not fetch nearby station.")
        }
    }
}

// MARK: AQIBannerProtocol

extension MapViewController : AQIBannerProtocol {
    
    func didRequestAQIUpdate() {
        fetchAQIUpdate()
    }
}

// MARK: Helpers

extension MapViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
