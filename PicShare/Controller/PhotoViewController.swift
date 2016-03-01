//
//  PhotoViewController.swift
//  PicShare
//
//  Created by James Valaitis on 01/03/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: Photo View Controller

/**
    `PhotoViewController`

    A view controller to simply display a photo.
 */
class PhotoViewController: UIViewController {
    
    //	MARK: Properties
    
    @IBOutlet private var photoImageView: UIImageView!
    private let photoFetchQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "Photo Fetch Queue"
        return queue
    }()
    /// The photo object to display.
    var photo: Photo? {
        didSet {
            guard let photo = photo where isViewLoaded() else { return }
            
            updateUIWithPhoto(photo)
        }
    }
    
    //	MARK: UI Functions
    
    func updateUIWithPhoto(photo: Photo) {
        if navigationController != nil {
            displayStringValue(photo)
        }
        
        photoFetchQueue.addOperationWithBlock {
            guard let photoURL = photo.URL else { return }
            
            guard let data = NSData(contentsOfURL: photoURL),
                let image = UIImage(data: data) else {
                    return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.photoImageView.image = image
            }
            
        }
    }
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            updateUIWithPhoto(photo)
        }
    }
}