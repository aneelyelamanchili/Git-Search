//
//  GithubUsers.swift
//  Git Search
//
//  Created by Aneel Yelamanchili.
//  Copyright (c) 2016. All rights reserved.
//

import Foundation
import AFNetworking

private let usersUrl = "https://api.github.com/search/users"
private let clientId: String? = nil
private let clientSecret: String? = nil

// Model class that represents a GitHub repository
class GithubUsers: CustomStringConvertible {
    
    // Data to be collected from json result
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var userBio: String?
    var userLocation: String?
    var createdAt: String?
    var userAddress: String?
    
    // Initializes a GitHubUser from a JSON dictionary
    init(jsonResult: NSDictionary) {
        
        // Setting values after JSON object has been received
        if let ownerHandle = jsonResult["login"] as? String {
            self.ownerHandle = ownerHandle
        }
        
        if let ownerAvatarURL = jsonResult["avatar_url"] as? String {
            self.ownerAvatarURL = ownerAvatarURL
        }
        
        if let userAddress = jsonResult["html_url"] as? String {
            self.userAddress = userAddress
        }
        
        //        if let userBio = jsonResult["bio"] as? String {
        //            self.userBio = userBio
        //        }
        //        
        //        if let userLocation = jsonResult["location"] as? String {
        //            self.userLocation = userLocation
        //        }
        //        
        //        if let createdAt = jsonResult["created_at"] as? String {
        //            self.createdAt = createdAt
        //        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchUsers(_ settings: GithubUsersSearchSettings, successCallback: @escaping ([GithubUsers]) -> (), error: ((Error?) -> ())?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings)
        
        manager.get(usersUrl, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObject: Any) in
            if let response = responseObject as? NSDictionary, let results = response["items"] as? NSArray {
                var users: [GithubUsers] = []
                for result in results as! [NSDictionary] {
                    users.append(GithubUsers(jsonResult: result))
                }
                successCallback(users)
            }
        })
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings(_ settings: GithubUsersSearchSettings) -> [String: String] {
        var params: [String:String] = [:]
        if let clientId = clientId {
            params["client_id"] = clientId
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret
        }
        
        var q = ""
        
        if settings.isFilterByLocation {
            q = q + " location:\(settings.location)"
            print("\n\n\n\n")
            print(q)
        }
        
        // q is sent to the GitHub REST client to receive a JSON object response
        
        params["q"] = q
        params["sort"] = "stars"
        params["order"] = "desc"
        
        return params
    }
    
    // Creates a text representation of a GitHub User
    var description: String {
        let result = "[Name: \(self.ownerHandle!)]" +
        "\n\t[Avatar: \(self.ownerAvatarURL!)]" +
        "\n\t[Bio: \(userBio)]" +
        "\n\t[Location: \(userLocation)" +
        "\n\t[Created At: \(createdAt)" +
        "\n\t[URL: \(userAddress)"
        
        
//        if let userBio = self.userBio {
//            result = result + "\n\t[Bio: \(userBio)]"
//        }
//        
//        if let userLocation = self.userLocation {
//            result = result + "\n\t[Location: \(userLocation)"
//        }
//        
//        if let createdAt = self.createdAt {
//            result = result + "\n\t[Created At: \(createdAt)"
//        }
        
        return result
    }
}
