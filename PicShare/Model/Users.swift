//
//  PicShareResources.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

//	MARK: Users

/**
    `Users`

    The users resource.
    Can be used to load all user objects.
 */
class Users: JSONResource {
    
    //	MARK: Properties
    
    var JSONPath: String { return "users/" }
    /// An array of User objects loaded from the remote resource.
    var users = [User]()
    
    //	MARK: JSONResource Functions
    
    func processJSON(data: NSData) -> Bool {
        
        var JSON = [JSONValue]()
        
        do {
            JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [JSONValue] ?? []
        } catch {
            print("Error parsing data into JSON: \(data)")
            return false
        }
        
        for userDictionary in JSON {
            guard let user = User(JSON: userDictionary) else {
                continue
            }
            
            users.append(user)
        }
        
        return true
    }
}