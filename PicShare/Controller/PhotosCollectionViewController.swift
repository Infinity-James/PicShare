//
//  PhotosCollectionViewController.swift
//  PicShare
//
//  Created by James Valaitis on 01/03/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit


class PhotosCollectionViewController: UICollectionViewController {

    
    //	MARK: Properties
    
    private let reuseIdentifier = String(PhotoCollectionViewCell)
    private let photoFetchQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "Photo Fetch Queue"
        return queue
    }()
    
    private var photos = [Photo]()
    
    var photoAlbum: PhotoAlbum? {
        didSet {
            guard let photoAlbum = photoAlbum where isViewLoaded() else { return }
            
            updateUIWithPhotoAlbum(photoAlbum)
        }
    }
    
    //  MARK: UI Functions
    
    private func updateUIWithPhotoAlbum(photoAlbum: PhotoAlbum) {
        if navigationController != nil {
            displayStringValue(photoAlbum)
        }
        
        PicShareResource<Photo>.photosInAlbum(photoAlbum) { photos in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.photos = photos
                self.collectionView!.reloadData()
            }
        }
    }

    //  MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? PhotoCollectionViewCell else {
            fatalError("The correct cell was not dequeued for collection view: \(collectionView)")
        }
        
        let photo = photos[indexPath.item]
        guard let thumbnailURL = photo.thumbnailURL else { return cell }
        
        photoFetchQueue.addOperationWithBlock {
            guard let data = NSData(contentsOfURL: thumbnailURL) else { return }
            
            let image = UIImage(data: data)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                cell.photoThumbnail = image
            }
        }
        
        return cell
    }
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoAlbum = photoAlbum {
            updateUIWithPhotoAlbum(photoAlbum)
        }
    }
}