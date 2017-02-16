//
//  ViewController.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit
import MBProgressHUD

extension RepoResultsViewController: SettingsTableViewControllerDelegate {
    func didUpdateSearchSettings(sender: SettingsTableViewController, searchSettings: GithubRepoSearchSettings) {
        self.searchSettings = searchSettings
        doSearch()
    }
}

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Declare the search bar
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    
    // Shared model
    var repos: [GithubRepo]!
    
    @IBOutlet weak var reposTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Perform the first search when the view controller first loads
        doSearch()
    }
    
    func configureTableView() {
        reposTableView.delegate = self
        reposTableView.dataSource = self
        reposTableView.estimatedRowHeight = 100
        reposTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // Perform the search.
    fileprivate func doSearch() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            
            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }
            self.repos = newRepos
            self.reposTableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    // Prepares for settings menu to be modally presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "settingsTableViewControllerSegue") {
            let navigationViewController = segue.destination as! UINavigationController
            let settingsTableViewController = navigationViewController.topViewController as! SettingsTableViewController
            settingsTableViewController.delegate = self
            settingsTableViewController.searchSettings = searchSettings
        }
    }
    
    // MARK:- Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = self.repos {
            return repos.count
        } else {
            return 0
        }
    }
    
    // set the reuse identifier and fill the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reposTableView.dequeueReusableCell(withIdentifier: "repoTableViewCell", for: indexPath) as! GithubRepoTableViewCell
        if let repo = repos?[indexPath.row] {
            cell.repo = repo
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
        let repo = repos?[indexPath.row]
        UIApplication.shared.open(NSURL(string: (repo?.userAddress!)!)! as URL, options: [:], completionHandler: nil)
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}
