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
    A protocol that defines a remotely obtained resource.
 */
protocol RemoteResource {
    /// A naive method for caching data fetched by this resource. A real app would require a more robust solution.
    var dataCache: DataCache { get set }
}

/// Defines an object which can be used to naively cache data.
typealias DataCache = [String: NSData]
/// A closure which will be called when a remote resource has loaded it's data.
typealias RemoteResourceHandler = (success: Bool) -> ()

extension RemoteResource {
    /**
        Loads the data defined by this resource.
     
        - Parameter URLPath:    The path at which the data defined by this remote resource resides.
        - Parameter completion: A closure which will be executed upon completion the load (successful or otherwise).
     */
    mutating func load(URLPath: String, completion: RemoteResourceHandler?) {
        guard let URL = NSURL(string: URLPath) else { fatalError("Invalid URL for resource: \(URLPath)") }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL) { data, response, error in
            
            guard let HTTPResponse = response as? NSHTTPURLResponse, let data = data where error == nil else {
                print("Loading the remote resource failed.\n")
                if let error = error {
                    print("Error: \(error)")
                }
                completion?(success: false)
                return
            }
            
            print("Response Code: \(HTTPResponse.statusCode)")
            self.dataCache[URLPath] = data
            
            completion?(success: true)
        }
        
        task.resume()
    }
    
    /**
     *  Returns the data for a given URL.
     *
     *  :param: URL The URL at which the desired data resides.
     *  
     *  :returns:   The data for a given URL.
     */
    func dataForURL(URL: String) -> NSData? {
        return dataCache[URL]
    }
}

//	MARK: JSON Resource

/**
    A protocol which defines a JSON resource.
 */
protocol JSONResource: RemoteResource {
    var JSONHost: String { get }
    var JSONPath: String { get }
    
    func processJSON(success: Bool)
}

extension JSONResource {
    /// Default the host name to this app's main API.
    var JSONHost: String { return "" }
    /// Use the host and the path to generate a fully qualified URL.
    var JSONURL: String { return "http://" + JSONHost + JSONPath }
    
    /**
     *  The main function responsible for the loading of the JSON.
     *
     *  :param: completion  A handler called upon completion of the load, successful or otherwise.
     */
    
}