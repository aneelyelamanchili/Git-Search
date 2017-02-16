//
//  SettingsTableViewController.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func didUpdateSearchSettings(sender: SettingsTableViewController, searchSettings: GithubRepoSearchSettings)
}

enum SettingsTableSection : Int {
    case MinStarsSection = 0,
    LanguagesSection = 1
}

// Settings Menu View Controller
class SettingsTableViewController: UITableViewController {
    
    weak var delegate:SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    // To be modified
    var searchSettings = GithubRepoSearchSettings()
    
    // To not be modified
    var originalSearchSettings = GithubRepoSearchSettings()
    
    @IBOutlet weak var filterByLanguageSwitch: UISwitch!
    @IBOutlet weak var minimumStarsLabel: UILabel!
    @IBOutlet weak var minimumStarsSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLanguagesFilter()
        
        // Sets value of the slider and its label
        minimumStarsSlider.value = Float(searchSettings.minStars)
        minimumStarsLabel.text = "\(searchSettings.minStars)"
        
        // Updates search query
        originalSearchSettings = searchSettings
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Value changed action
    @IBAction func minimumStarsSliderValueChanged(_ sender: AnyObject) {
        let minStars = Int(minimumStarsSlider.value)
        minimumStarsLabel.text = "\(minStars)"
        searchSettings.minStars = minStars
    }
    
    // Switch changed action
    @IBAction func onFilterByLanguageSwitchValueChanged(_ sender: AnyObject) {
        let isFilterByLanguage = sender.isOn
        searchSettings.isFilterByLanguage = isFilterByLanguage!
        if (!searchSettings.isFilterByLanguage) {
            searchSettings.languages = []
        }
        tableView.reloadData()
    }
    
    // Dismiss modally presented view
    @IBAction func handleSaveButtonClicked(_ sender: AnyObject) {
        delegate?.didUpdateSearchSettings(sender: self, searchSettings: searchSettings)
        dismiss(animated: true, completion: nil)
    }
    
    // Dismiss modally presented view
    @IBAction func handleCancelButtonClicked(_ sender: AnyObject) {
        searchSettings = originalSearchSettings
        dismiss(animated: true, completion: nil)
    }
    
    func configureLanguagesFilter() {
        filterByLanguageSwitch.isOn = searchSettings.isFilterByLanguage
        var row = 1
        let isFilterByLanguageOrigValue = searchSettings.isFilterByLanguage
        searchSettings.isFilterByLanguage = true // to fill static cells show all rows
        
        print (tableView.numberOfRows(inSection: SettingsTableSection.LanguagesSection.rawValue))
        for language in GithubRepoLanguage.allValues {
            let indexPath = IndexPath.init(row: row, section: SettingsTableSection.LanguagesSection.rawValue)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = language.rawValue
            if (searchSettings.languages?.contains(language))! {
                cell?.accessoryType = .checkmark
            }
            row += 1
        }
        
        searchSettings.isFilterByLanguage = isFilterByLanguageOrigValue
    }
    
    func updateLanguagesFilter(tableView: UITableView, didChangeRowSelectionAt indexPath: IndexPath)  {
        if let cell = tableView.cellForRow(at: indexPath) {
            let cellLanguage = cell.textLabel?.text
            
            switch cell.accessoryType {
            case .checkmark:
                // Don't filter by this language
                cell.accessoryType = .none
                if let cellLanguage = cell.textLabel?.text {
                    print(cellLanguage)
                    if let languages = searchSettings.languages {
                        if let language = GithubRepoLanguage(rawValue: cellLanguage) {
                            if let index = languages.index(of: language) {
                                searchSettings.languages?.remove(at: index)
                            }
                        }
                    }
                }
            case .none:
                cell.accessoryType = .checkmark
                let language = GithubRepoLanguage(rawValue: cellLanguage!)
                searchSettings.languages?.append(language!)
            default:
                cell.accessoryType = .none
            }
        }
    }
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            let constRowsCount = 1
            return searchSettings.isFilterByLanguage ? GithubRepoLanguage.allValues.count + constRowsCount : constRowsCount
            
        default:
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateLanguagesFilter(tableView: tableView, didChangeRowSelectionAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateLanguagesFilter(tableView: tableView, didChangeRowSelectionAt: indexPath)
        
    }
    
}
