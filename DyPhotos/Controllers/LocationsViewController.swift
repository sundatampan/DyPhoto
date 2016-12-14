//
//  LocationsViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UITableViewController, CLLocationManagerDelegate {
    
    private var location: CLLocation?
    private lazy var locationManager: CLLocationManager =  {
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
        return manager
    }()
    
    var locations = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        loadLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPhotos" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let location = locations[indexPath.row]
                    let viewController = segue.destinationViewController as! PhotosViewController
                    viewController.location = location
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func locationDidUpdate(sender: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kLocationDidUpdateNotification, object: nil)
        loadLocations()
    }
    
    func loadLocations() {
        
        if let location = location {
            Engine.shared.searchLocations(location.coordinate.latitude, longitude: location.coordinate.longitude) { (result, error) -> () in
                
                self.refreshControl?.endRefreshing()
                
                if let response = result as? [[String: AnyObject]] {
                    
                    self.locations = response
                    self.tableView.reloadData()
                }
                else if let _ = error {
                    
                }
                else {
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationsViewController.locationDidUpdate(_:)), name: kLocationDidUpdateNotification, object: nil)
                }
            }
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(sender: UIRefreshControl) {
        loadLocations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCellId", forIndexPath: indexPath)
        
        // Configure the cell...
        let location = locations[indexPath.row]
        if let name = location["name"] as? String {
            cell.textLabel?.text = name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showPhotos", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations[0]
        location = newLocation
        
        loadLocations()
        manager.stopUpdatingLocation()
    }
}
