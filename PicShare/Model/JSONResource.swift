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
        
        print("FILE NAME: \(resourceFileName)")
        
        if let data = DataCache.dataForKey(resourceFileName) {
            processJSON(data)
            NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: true) }
        } else {
        
            load(JSONURL) { data, success in
                //  processing the result is down to the adopter of this protocol
                if let data = data where success {
                    DataCache.storeData(data, forKey: self.resourceFileName)
                    let success = self.processJSON(data)
                    NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: success) }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock { completion?(success: false) }
                }
            }
        }
    }
    
    private var resourceFileName: String {
        //  the file name will firstly consist of the URL but in a safe way
        let safeURL = JSONURL.stringByReplacingOccurrencesOfString("/", withString: "")
        
        //  to that we will add the most recent hour
        //  this is so that we refresh the resource every hour because otherwise the JSON on the server could have changed
        //  and our JSON would be stale
        let now = NSDate()
        let hourComponent = NSCalendar.currentCalendar().components(.Hour, fromDate: now).hour
        let date = NSCalendar.currentCalendar().dateBySettingHour(hourComponent, minute: 0, second: 0, ofDate: now, options: .MatchNextTime)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMddyyHH"
        let fileName = safeURL + dateFormatter.stringFromDate(date)
        return fileName
    }
}

/// A string that uniquely identifies an object.
typealias Identifier = Int

protocol JSONInitializable {
    init?(JSON: JSONValue)
}

//	MARK: PicShare Resource

/**
    `PicShareResource`

    A generic class that can be used to load certain PicShare objects.
    When given a JSON path the PicShare objects can be loaded from it.
*/
class PicShareResource<T: JSONInitializable>: JSONResource {
    
    //	MARK: Properties
    
    let JSONPath: String
    /// The array of objects loaded from the given path.
    var resourceObjects = [T]()
    
    /**
        Initializes a PicShareResource with the path to load the resources from.
     
        - Parameter JSONPath:   The path at which the resource resides.
     
        - Returns:  An initialized PicShareResource object.
     */
    init(JSONPath: String) {
        self.JSONPath = JSONPath
    }
    
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
            guard let object = T(JSON: userDictionary) else {
                continue
            }
            
            resourceObjects.append(object)
        }
        
        return true
    }
}

//	MARK: Pic Share Resources

extension PicShareResource {
    static func allUsers(completion: [User] -> ()) {
        var resource = PicShareResource<User>(JSONPath: "users/")
        
        resource.loadJSON { success in
            completion(resource.resourceObjects)
        }
    }
    static func allPhotoAlbums(completion: [PhotoAlbum] -> ()) {
        var resource = PicShareResource<PhotoAlbum>(JSONPath: "albums/")
        resource.loadJSON { success in
            completion(resource.resourceObjects)
        }
    }
    static func allPhotos(completion: [Photo] -> ()) {
        var resource = PicShareResource<Photo>(JSONPath: "photos/")
        resource.loadJSON { success in
            completion(resource.resourceObjects)
        }
    }
}


extension PicShareResource {
    
    /**
        Fetches the photo albums associated with a given user.
     
        - Parameter user:           The user for which we fetch the photo albums.
        - Parameter completion:     Called with the fetched photo albums.
     */
    static func photoAlbumsForUser(user: User, completion: ([PhotoAlbum]) -> ()) {
        allPhotoAlbums { albums in
            let userAlbums = albums.filter { album in
                album.userIdentifier == user.identifier
            }
            
            completion(userAlbums)
        }
    }
    
    /**
        Fetches the photo albums associated with a given user.
     
        - Parameter album:         The photo albums containing the photos to be fetched.
        - Parameter completion:    Called with the fetched photos.
     */
    static func photosInAlbum(album: PhotoAlbum, completion: ([Photo]) -> ()) {
        allPhotos { photos in
            let albumPhotos = photos.filter { photo in
                photo.albumIdentifier == album.identifier
            }
            
            completion(albumPhotos)
        }
    }
}