//
//  GithubRepo.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import Foundation
import AFNetworking

private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = nil
private let clientSecret: String? = nil

// Model class that represents a GitHub repository
class GithubRepo: CustomStringConvertible {
    
    // Data to be collected from json result
    var name: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    var repoDescription: String?
    var language: String?
    var userAddress: String?
    
    // Initializes a GitHubRepo from a JSON dictionary
    init(jsonResult: NSDictionary) {
        
        // Setting values after JSON object has been received
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int? {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int? {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
        
        if let repoDescription = jsonResult["description"] as? String {
            self.repoDescription = repoDescription
        }
        
        if let repoLanguage = jsonResult["language"] as? String {
            self.language = repoLanguage
        }
        
        if let userAddress = jsonResult["html_url"] as? String {
            self.userAddress = userAddress
        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchRepos(_ settings: GithubRepoSearchSettings, successCallback: @escaping ([GithubRepo]) -> (), error: ((Error?) -> ())?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings)
        
        manager.get(reposUrl, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObject: Any) in
            if let response = responseObject as? NSDictionary, let results = response["items"] as? NSArray {
                var repos: [GithubRepo] = []
                for result in results as! [NSDictionary] {
                    repos.append(GithubRepo(jsonResult: result))
                }
                successCallback(repos)
            }
        })
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings(_ settings: GithubRepoSearchSettings) -> [String: String] {
        var params: [String:String] = [:]
        if let clientId = clientId {
            params["client_id"] = clientId
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret
        }
        
        var q = ""
        if let searchString = settings.searchString {
            q = q + searchString
        }
        q = q + " stars:>\(settings.minStars)"
        
        if settings.isFilterByLanguage {
            var qLanguage = ""
            for language in settings.languages! {
                qLanguage = qLanguage + " language:\(language)"
            }
            
            q = q + qLanguage
        }
        
        if settings.isFilterByLocation {
            q = q + " Pleasanton"
            print("\n\n\n\n")
            print(q)
        }
        
        // q is sent to the GitHub REST client to receive a JSON object response
        
        params["q"] = q
        params["sort"] = "stars"
        params["order"] = "desc"
        
        return params
    }
    
    // Creates a text representation of a GitHub repo
    var description: String {
        var result = "[Name: \(self.name!)]" +
            "\n\t[Stars: \(self.stars!)]" +
            "\n\t[Forks: \(self.forks!)]" +
            "\n\t[Owner: \(self.ownerHandle!)]" +
        "\n\t[Avatar: \(self.ownerAvatarURL!)]" +
        "\n\t[URL: \(self.userAddress)]"
        
        if let repoDescription = self.repoDescription {
            result = result + "\n\t[Description: \(repoDescription)]"
        }
        
        if let language = self.language {
            result = result + "\n\t[Language: \(language)]"
        }
        
        return result
    }
}
