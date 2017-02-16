//
//  ViewController.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation

extension LocationResultsViewController: SettingsTableViewControllerDelegate {
    internal func didUpdateSearchSettings(sender: SettingsTableViewController, searchSettings: GithubRepoSearchSettings) {

    }

    func didUpdateSearchSettings(sender: SettingsTableViewController, searchSettings: GithubUsersSearchSettings) {
        self.searchSettings = searchSettings
        doSearch()
    }
}

// Location ViewController
class LocationResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var searchSettings = GithubUsersSearchSettings()
    
    var locationManager = CLLocationManager()
    
    // Shared model
    var users: [GithubUsers]!
    
    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Asynchronously collects user data and displays it based on the user's location
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Accounts for asynchronous runtime
        while locationManager.location?.coordinate.latitude == nil && locationManager.location?.coordinate.longitude == nil {
            locationManager.delegate = self
            
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            print("\(locationManager.location?.coordinate.latitude)")
            print("\(locationManager.location?.coordinate.longitude)")
        }
        
        // Reverse geocaches the coordinates to get the city name to be used in the API query
        if locationManager.location?.coordinate.latitude != nil && locationManager.location?.coordinate.longitude != nil {
            let location:CLLocation = locationManager.location! //changed!!!
            print(location)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                print(location)
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks?[0] as CLPlacemark!
                    print(pm?.locality)
                    self.searchSettings.location = (pm?.locality)!
                    
                    self.searchSettings.isFilterByLocation = true;
                    
                    
                    self.configureTableView()
                    
                    // Perform the first search when the view controller first loads
                    self.doSearch()
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
        
    }
    
    func configureTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.estimatedRowHeight = 100
        usersTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // Perform the search.
    fileprivate func doSearch() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // Perform request to GitHub API to get the list of users
        GithubUsers.fetchUsers(searchSettings, successCallback: { (newUsers) -> Void in
            
            // Print the returned users to the output window
            for user in newUsers {
                print(user)
            }
            self.users = newUsers
            self.usersTableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    // MARK:- Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = self.users {
            return users.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "usersTableViewCell", for: indexPath) as! GithubUsersTableViewCell
        if let user = users?[indexPath.row] {
            cell.user = user
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users?[indexPath.row]
        UIApplication.shared.open(NSURL(string: (user?.userAddress!)!)! as URL, options: [:], completionHandler: nil)
    }
}
