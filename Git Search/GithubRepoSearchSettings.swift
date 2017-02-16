//
//  GithubRepoSearchSettings.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import Foundation

// Languages that can be filtered through
enum GithubRepoLanguage : String {
    case Java = "Java",
    JavaScript = "JavaScript",
    ObjectiveC = "Objective C",
    Python = "Python",
    Ruby = "Ruby",
    Swift = "Swift"
    
    static let allValues = [Java, JavaScript, ObjectiveC, Python, Ruby, Swift]
}

// Check Repo language equality
extension GithubRepoLanguage :Equatable {
    static func == (lhs: GithubRepoLanguage, rhs: GithubRepoLanguage) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// Model class that represents the user's search settings
struct GithubRepoSearchSettings {
    var searchString: String?
    var minStars = 0
    var isFilterByLanguage = false
    var languages: [GithubRepoLanguage]? = []
    var isFilterByLocation = false
    var location = "cupertino"
    
    init() {
        
    }
}
