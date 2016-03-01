//
//  PhotoAlbumTableViewCell.swift
//  PicShare
//
//  Created by James Valaitis on 01/03/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: Photo Album Table View Cell

/**
    `PhotoAlbumTableViewCell`

    In a table view this cell will represent a photo album.
*/
class PhotoAlbumTableViewCell: UITableViewCell {
    
    //	MARK: Properties
    
    /// A label used to display the user as a string.
    @IBOutlet var albumTitleLabel: UILabel!
    
    //	MARK: StringDisplay
    
    override var containerSize: CGSize { return albumTitleLabel.frame.size }
    override var containerFont: UIFont { return albumTitleLabel.font }
    
    override func assignString(string: String) {
        albumTitleLabel.text = string
    }
}