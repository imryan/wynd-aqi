//
//  AQIBanner.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit

protocol AQIBannerProtocol {
    func didRequestAQIUpdate()
}

class AQIBanner: UIView {
    
    var delegate: AQIBannerProtocol?
    var aqi: AQI?
    
    var aqiLabel: UILabel!
    var concernLabel: UILabel!
    var meaningLabel: UILabel!
    var lastUpdateLabel: UILabel!
    var refreshButton: UIButton!
    
    // MARK: Initialization
    
    public init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Functions
    
    public func updateWithAQI(_ aqi: AQI) {
        self.aqi = aqi
        updateUI()
    }
    
    @objc private func requestAQIUpdate() {
        delegate?.didRequestAQIUpdate()
    }
    
    // MARK: UI
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.withAlphaComponent(UIColor.gray)(0.8)
        
        // AQI
        aqiLabel = UILabel()
        aqiLabel.translatesAutoresizingMaskIntoConstraints = false
        aqiLabel.text = "0"
        aqiLabel.font = UIFont.boldSystemFont(ofSize: 50)
        aqiLabel.textColor = UIColor.white
        addSubview(aqiLabel)
        
        // Concern
        concernLabel = UILabel()
        concernLabel.translatesAutoresizingMaskIntoConstraints = false
        concernLabel.text = "N/A"
        concernLabel.font = UIFont.boldSystemFont(ofSize: 25)
        concernLabel.textColor = UIColor.white
        addSubview(concernLabel)
        
        // Meaning
        meaningLabel = UILabel()
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.numberOfLines = 0
        meaningLabel.minimumScaleFactor = 12.0
        meaningLabel.text = "N/A"
        meaningLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        meaningLabel.textColor = .white
        addSubview(meaningLabel)
        
        // Last update
        lastUpdateLabel = UILabel()
        lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdateLabel.text = "Last updated at --:--"
        lastUpdateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lastUpdateLabel.textColor = UIColor.withAlphaComponent(.white)(0.7)
        addSubview(lastUpdateLabel)
        
        // Refresh
        refreshButton = UIButton()
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        refreshButton.addTarget(self, action: #selector(requestAQIUpdate), for: .touchUpInside)
        addSubview(refreshButton)
    }
    
    private func updateUI() {
        if let aqi = self.aqi {
            self.backgroundColor = UIColor.withAlphaComponent(aqi.color)(0.85)
            
            self.aqiLabel.text = String(aqi.index!)
            self.concernLabel.text = aqi.concern.uppercased()
            self.meaningLabel.text = aqi.meaning
            self.lastUpdateLabel.text = "Last updated at \(String.prettyDateString(date: Date(), full: false))"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // HUD
            self.bottomAnchor.constraint(equalTo: lastUpdateLabel.bottomAnchor, constant: 8),
            
            // AQI value
            aqiLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            aqiLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            // AQI concern
            concernLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            concernLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            // AQI value
            meaningLabel.topAnchor.constraint(equalTo: aqiLabel.bottomAnchor, constant: 0),
            meaningLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            meaningLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            // Last update
            lastUpdateLabel.topAnchor.constraint(equalTo: meaningLabel.bottomAnchor, constant: 4),
            lastUpdateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            // Refresh button
            refreshButton.heightAnchor.constraint(equalToConstant: 15),
            refreshButton.topAnchor.constraint(equalTo: meaningLabel.bottomAnchor, constant: 4),
            refreshButton.leadingAnchor.constraint(equalTo: lastUpdateLabel.trailingAnchor, constant: 8)
        ])
    }
}
