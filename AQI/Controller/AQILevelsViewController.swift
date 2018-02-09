//
//  AQILevelsViewController.swift
//  AQI
//
//  Created by Ryan Cohen on 1/30/18.
//  Copyright © 2018 Wynd. All rights reserved.
//

import UIKit

class AQILevelsViewController : UITableViewController {
    
    var displayButton: UIButton!
    var shouldDisplayArchived = false
    
    var dataSource: [AQI] {
        if shouldDisplayArchived {
            return StationService.shared.aqiLogs
        }
        
        return AQI.allLevels()
    }
    
    
    // MARK: Functions
    
    @objc func toggleDisplayArchived() {
        shouldDisplayArchived = !shouldDisplayArchived
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

// MARK: UITableViewDelegate

extension AQILevelsViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: UITableViewDataSource

extension AQILevelsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "AQI"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            displayButton = UIButton()
            displayButton.setTitle("Display historic data", for: .normal)
            displayButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            displayButton.setTitleColor(UIColor.darkGray, for: .normal)
            displayButton.addTarget(self, action: #selector(toggleDisplayArchived), for: .touchUpInside)
            
            return displayButton
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AQITableViewCell
        
        let aqi = dataSource[indexPath.row]
        cell.setupWithAQI(aqi)
        
        return cell
    }
}
