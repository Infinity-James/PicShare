//
//  ResourceCache.swift
//  PicShare
//
//  Created by James Valaitis on 01/03/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: Image Fetch Operation

/**
    `ImageFetchOperation`

    An operation that will fetch images from the remote source.
    If the image has been fetched before hand it can be accessed from a cache.
 */
class ImageFetchOperation: NSOperation {
    
    //	MARK: Properties
    
    let imageURL: NSURL
    var image: UIImage?
    
    //	MARK: Initialization
    
    /**
        Initializes the operation with the URL from which we fetch the image.
     */
    init(imageURL: NSURL) {
        self.imageURL = imageURL
        
        super.init()
    }
    
    //	MARK: Operation
    
    override func main() {
        
        var fetchedFromCache = false
        
        
        let data: NSData?
        
        if let cachedData = DataCache.dataForKey(imageURL.lastPathComponent!) {
            data = cachedData
            fetchedFromCache = true
        } else {
            data = NSData(contentsOfURL: imageURL)
        }
        
        guard let imageData = data,
            image = UIImage(data: imageData) else {
            cancel()
            return
        }
        
        if !fetchedFromCache {
            DataCache.storeData(imageData, forKey: imageURL.lastPathComponent!)
        }
        
        self.image = image
    }
}

//	MARK: Data Cache

/**
    An object capable of caching data.
 */
private struct DataCache {
    
    //	10Mb is max size of cache
    private static let maxCacheSize = 10485760
    //	10Mb is the size of the cache at which we stop trimming
    private static let trimCacheSize = 5242880
    
    private static let cacheURL: NSURL = {
        let cachesDirectories = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return cachesDirectories.last!
    }()
    
    //	MARK: Cache Management
    
    /**
        Trims the cache if necessary.
     */
    static private func trimCache() {
        
        //  get all of the files in the cache
        let URLsInCache = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(cacheURL, includingPropertiesForKeys: [], options: .SkipsHiddenFiles)
        var cacheSize = 0
        URLsInCache.forEach { cacheSize += $0.fileSize ?? 0 }

//        print("Cache Size: \(cacheSize / 1000)Mb")
        
        //  if the cache is still small enough we can exit early
        guard cacheSize < maxCacheSize else { return }
        
        let sortedURLs = URLsInCache.sort { urlA, urlB in
            return urlA.creationDate!.compare(urlB.creationDate!) == .OrderedDescending
        }
        
        for URL in sortedURLs where cacheSize > trimCacheSize {
            
            if URL.fileType == NSFileTypeRegular {
                cacheSize -= URL.fileSize!
                try! NSFileManager.defaultManager().removeItemAtURL(URL)
            }
        }
    }
    
    //	MARK: Data Management
    
    static func dataForKey(key: String) -> NSData? {
        let URL = URLForDataWithKey(key)
        return NSData(contentsOfURL: URL)
    }
    
    static func storeData(data: NSData, forKey key: String) {
        //  write data to file system
        data.writeToURL(URLForDataWithKey(key), atomically: true)
        
        //  make sure cache is not too big
        let dispatchQueue = dispatch_queue_create("trimCache", nil);
        
        dispatch_async(dispatchQueue) {
            trimCache()
        }
    }
    
    private static func URLForDataWithKey(key: String) -> NSURL {
        return NSURL(string: key, relativeToURL: cacheURL)!
    }
}

//	MARK: NSURL - Convenience Attributes

extension NSURL {
    
    var attributes: [String: AnyObject]? {
        let attributes: [String: AnyObject]?
        do {
            attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(absoluteString)
        } catch {
            attributes = nil
        }
        
        return attributes
    }
    
    var fileSize: Int? {
        var fileSize: AnyObject?
        try! getResourceValue(&fileSize, forKey: NSFileSize)
        
        if fileSize == nil {
            fileSize = attributes?[NSFileSize]
        }
        
        return fileSize as? Int
    }
    
    var creationDate: NSDate? {
        var creationDate: AnyObject?
        try! getResourceValue(&creationDate, forKey: NSURLCreationDateKey)
        
        if creationDate == nil {
            creationDate = attributes?[NSURLCreationDateKey]
        }
        
        return creationDate as? NSDate
    }
    
    var fileType: String? {
        var fileType: AnyObject?
        try! getResourceValue(&fileType, forKey: NSFileType)
        
        if fileType == nil {
            fileType = attributes?[NSFileType]
        }
        
        return fileType as? String
    }
}