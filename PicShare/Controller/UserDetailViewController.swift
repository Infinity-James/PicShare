//
//  UserDetailViewController.swift
//  PicShare
//
//  Created by James Valaitis on 29/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: User Detail View Controller

/**
    `UserDetailViewController`

    Displays details about the user as well as their albums.
 */
class UserDetailViewController: UIViewController {
    
    //	MARK: Properties - State
    
    var user: User? {
        didSet {
            guard let user = user where isViewLoaded() else { return }
            
            updateUIWithUser(user)
        }
    }
    
    var photoAlbums = [PhotoAlbum]()
    
    //	MARK: Properties - Subviews
    
    /// The table view which lists the user's albums.
    @IBOutlet var tableView: UITableView!
    /// Displays the user's full name.
    @IBOutlet var nameLabel: UILabel!
    /// Displays the user's username.
    @IBOutlet var usernameLabel: UILabel!
    /// Displays the user's Company name.
    @IBOutlet var companyLabel: UILabel!
    /// Displays the bull that company pushes as their 'USP'.
    @IBOutlet var companyBSLabel: UILabel!
    /// Displays the user's email address.
    @IBOutlet var emailLabel: UILabel!
    /// Displays the user's website.
    @IBOutlet var websiteLabel: UILabel!
    
    //	MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            fatalError("There is an unexpected segue without an identifier in UsersTableViewController: \(segue).")
        }
        
        switch segueIdentifier {
        case String(PhotosCollectionViewController):
            guard let photosVC = segue.destinationViewController as? PhotosCollectionViewController else { fatalError("Incorrect view controller for the segue \"\(String(PhotosCollectionViewController))\".") }
            let selectedAlbum = photoAlbums[tableView.indexPathForSelectedRow!.row]
            photosVC.photoAlbum = selectedAlbum
            
        default:
            fatalError("There is an unexpected segue with the identifier \"\(segueIdentifier)\" in UserDetailViewController.")
        }
    }
    
    //	MARK: UI Functions
    
    private func updateUIWithUser(user: User) {
        
        if navigationController != nil {
            displayStringValue(user)
        }
        
        //  update the UI with the new user details
        nameLabel.text = user.name
        usernameLabel.text = user.username
        companyLabel.text = user.company.name
        companyBSLabel.text = user.company.bull
        emailLabel.text = user.email
        websiteLabel.text = user.website
        
        PicShareResource<User>.photoAlbumsForUser(user) { albums in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.photoAlbums = albums
                self.tableView.reloadData()
            }
        }
    }
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            updateUIWithUser(user)
        }
    }
}

//	MARK: UITableViewDataSource

extension UserDetailViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(String(PhotoAlbumTableViewCell), forIndexPath: indexPath) as? PhotoAlbumTableViewCell else {
            fatalError("The correct cell was not dequeued for table view: \(tableView)")
        }
        
        let album = photoAlbums[indexPath.row]
        cell.displayStringValue(album)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoAlbums.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Albums"
        default:
            fatalError("There should only be one section in the photo albums table view.")
        }
    }
}