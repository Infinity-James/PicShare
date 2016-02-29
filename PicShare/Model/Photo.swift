//
//  Photo.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

//	MARK: Photo

/**
    `Photo`

    Represents a photo.
 */
struct Photo: JSONInitializable {
    //	MARK: Properties
    
    /// The unique identifier for the album that holds this photo.
    let albumIdentifier: Identifier
    /// The unique identifier for this photo.
    let identifier: Identifier
    /// The title given to this photo.
    let title: String
    /// The URL for the full photo as a string.
    let URLString: String
    /// The URL for the full photo.
    var URL: NSURL? {
        return NSURL(string: URLString)
    }
    /// The URL for the thumbnail as a string.
    let thumbnailURLString: String
    /// The URL for the thuimbnail.
    var thumbnailURL: NSURL? {
        return NSURL(string: thumbnailURLString)
    }
    
    //	MARK: Initialisation
    
    /**
        Initialises a Photo from it's JSON representation.
     */
    init?(JSON: JSONValue) {
        guard let albumID = JSON["albumId"] as? Identifier,
            ID = JSON["id"] as? Identifier,
            photoTitle = JSON["title"] as? String,
            photoURL = JSON["url"] as? String,
            photoThumbnailUrl = JSON["thumbnailUrl"] as? String else {
                print("Invalid representation of a Photo: \(JSON)")
                return nil
        }
        
        albumIdentifier = albumID
        identifier = ID
        title = photoTitle
        URLString = photoURL
        thumbnailURLString = photoThumbnailUrl
    }
}

//	MARK: StringRepresentable

extension Photo: StringRepresentable {
    var shortString: String {
        let range = title.startIndex..<title.startIndex.advancedBy(10)
        return title.substringWithRange(range)
    }
    var mediumString: String {
        let range = title.startIndex..<title.startIndex.advancedBy(20)
        return title.substringWithRange(range)
    }
    var longString: String { return title }
}