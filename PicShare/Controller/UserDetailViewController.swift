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
            guard let user = user else { return }
            
            //  update the UI with the new user details
            nameLabel.text = user.name
            usernameLabel.text = user.username
            companyLabel.text = user.company.name
            companyBSLabel.text = user.company.bull
            emailLabel.text = user.email
            websiteLabel.text = user.website
        }
    }
    
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
    
    
}