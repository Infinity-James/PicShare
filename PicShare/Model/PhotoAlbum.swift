//
//  PhotoAlbum.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

//	MARK: Photo Album

/**
    `PhotoAlbum`

    An album of photos.
 */
struct PhotoAlbum {
    //	MARK: Properties
    
    /// The unique identifier for this album.
    let identifier: Identifier
    /// The identifier of the user who owns this album.
    let userIdentifier: Identifier
    /// The title of the photo album.
    let title: String
    
    /**
        Creates a PhotoAlbum from te provided JSON representation.
     */
    init?(JSON: JSONValue) {
        guard let id = JSON["id"] as? Identifier,
        userID = JSON["userId"] as? Identifier,
            albumTitle = JSON["title"] as? String else {
                print("Invalid representation of a Photo Album: \(JSON)")
                return nil
        }
        
        identifier = id
        userIdentifier = userID
        title = albumTitle
    }
}