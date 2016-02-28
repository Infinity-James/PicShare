//
//  APIClient.swift
//  PicShare
//
//  Created by James Valaitis on 25/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

//	MARK: Remote Resource

/**
    `RemoteResource`

    A protocol that defines a remotely obtained resource.
 */
protocol RemoteResource {
}

/// A dictionary representing JSON.
typealias JSONValue = [String: AnyObject]

extension RemoteResource {
    /**
        Loads the data defined by this resource.
     
        - Parameter URLPath:    The path at which the data defined by this remote resource resides.
        - Parameter completion: A closure which will be executed upon completion the load (successful or otherwise).
     */
    mutating func load(URLPath: String, completion: ((data: NSData?, success: Bool) -> ())?) {
        guard let URL = NSURL(string: URLPath) else { fatalError("Invalid URL for resource: \(URLPath)") }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL) { data, response, error in
            
            guard let HTTPResponse = response as? NSHTTPURLResponse, let data = data where error == nil else {
                print("Loading the remote resource failed.\n")
                if let error = error {
                    print("Error: \(error)")
                }
                completion?(data: nil, success: false)
                return
            }
            
            print("Response Code: \(HTTPResponse.statusCode)")
            
            completion?(data: data, success: true)
        }
        
        task.resume()
    }
}

//	MARK: JSON Resource

/**
    `JSONResource`

    A protocol which defines a JSON resource.
 */
protocol JSONResource: RemoteResource {
    /// The host of the server where the JSON resides.
    var JSONHost: String { get }
    /// The path on the host for this JSON resource.
    var JSONPath: String { get }
    
    /**
        Processes the JSON data in place.
     
        - Parameter data:   The JSON data to be processed.
     
        - Returns:  Whether or not the JSON was processed successfully.
     */
    mutating func processJSON(data: NSData) -> Bool
}

extension JSONResource {
    /// Default the host name to this app's main API.
    var JSONHost: String { return "jsonplaceholder.typicode.com/" }
    /// Use the host and the path to generate a fully qualified URL.
    var JSONURL: String { return "http://" + JSONHost + JSONPath }
    
    /**
        The main function responsible for the loading of the JSON.
     */
    mutating func loadJSON(completion: ((success: Bool) -> ())?) {
        load(JSONURL) { data, success in
            //  processing the result is down to the adopter of this protocol
            if let data = data where success {
                let success = self.processJSON(data)
                NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: success) }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: false) }
            }
        }
    }
}

/// A string that uniquely identifies an object.
typealias Identifier = Int