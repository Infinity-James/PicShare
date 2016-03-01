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
        
        guard let data = NSData(contentsOfURL: imageURL),
            image = UIImage(data: data) else {
            cancel()
            return
        }
        
        self.image = image
    }
}

private struct ImageCache {
    
    //	10Mb is max size of cache
    private static let maxCacheSize = 10485760
    //	10Mb is the size of the cache at which we stop trimming
    private static let trimCacheSize = 5242880
    
    private static let cacheURL: NSURL = {
        let cachesDirectories = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return cachesDirectories.last!
    }()
    
    static func trimCache() {
        
        //  get all of the files in the cache
        let URLsInCache = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(cacheURL, includingPropertiesForKeys: [NSFileType, NSFileSize, NSURLCreationDateKey], options: .SkipsHiddenFiles)
        var cacheSize = 0
        URLsInCache.forEach { cacheSize += $0.fileSize! }

        print("Cache Size: \(cacheSize / 1000)Mb")
        
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
}

//	MARK: NSURL - Convenience Attributes

extension NSURL {
    var fileSize: Int? {
        var fileSize: AnyObject?
        try! getResourceValue(&fileSize, forKey: NSFileSize)
        return fileSize as? Int
    }
    
    var creationDate: NSDate? {
        var creationDate: AnyObject?
        try! getResourceValue(&creationDate, forKey: NSURLCreationDateKey)
        return creationDate as? NSDate
    }
    
    var fileType: String? {
        var fileType: AnyObject?
        try! getResourceValue(&fileType, forKey: NSFileType)
        return fileType as? String
    }
}