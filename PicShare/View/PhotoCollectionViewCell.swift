//
//  PhotoCollectionViewCell.swift
//  PicShare
//
//  Created by James Valaitis on 01/03/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: Photo Collection View Cell

/**
    `PhotoCollectionViewCell`

    A cell whose only purpose is to represent a photo.
 */
class PhotoCollectionViewCell: UICollectionViewCell {
    //	MARK: Properties
    
    @IBOutlet private var photoThumbnailImageView: UIImageView!
    /// The photo as a thumbnail.
    var photoThumbnail: UIImage? {
        didSet {
            photoThumbnailImageView.image = photoThumbnail
        }
    }
}