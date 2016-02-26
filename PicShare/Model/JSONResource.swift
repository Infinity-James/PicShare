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
/// A dictionary representing JSON.
typealias JSONValue = [String: AnyObject]

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
        Returns the data for a given URL.

        - Parameter URL: The URL at which the desired data resides.
     
        - Returns:  The data for a given URL.
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
        The main function responsible for the loading of the JSON.
     
        - Parameter completion:  A handler called upon completion of the load, successful or otherwise.
     */
    mutating func loadJSON(completion: RemoteResourceHandler?) {
        load(JSONURL) { success in
            //  processing the result is down to the adopter of this protocol
            self.processJSON(success)
            
            //  call completion on main queue
            NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: success) }
        }
    }
}

extension JSONResource {
    /// This JSON resource as a JSON value. (JSON is lowercase here to avoid problems with it being mistaken for the type `JSONValue`)
    var jsonValue: JSONValue? {
        do {
            if let data = dataForURL(JSONURL), result = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? JSONValue {
                return result
            }
        } catch {
            print("Error attempting to serialise JSON: \(error)")
        }
        
        return nil
    }
}

////	MARK: Unique
//
///**
//    Defines a protocol for any entity which has a unique identifier.
// */
//protocol Unique {
//    var identifier: String { get }
//}
//
//extension Unique where Self: NSObject {
//    /**
//        A default initialiser for any unique object.
//    
//        - Parameter id  A unique identifier for this object. Defaults to random unique string.
//    
//        - Returns: An instance os this Unique object.
//     */
//    init(id: String = NSUUID().UUIDString) {
//        self.init()
//        
//        identifier = id
//    }
//}
//
///**
//    Compares 2 unique objects by checking the identifiers.
// */
//func ==(left: Unique, right: Unique) -> Bool {
//    return left.identifier == right.identifier
//}
//
//extension NSObjectProtocol where Self: Unique {
//    func isEqual(object: AnyObject?) -> Bool {
//        if let object = object as? Unique {
//            return object.identifier == identifier
//        }
//        
//        return false
//    }
//}