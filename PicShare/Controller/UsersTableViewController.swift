//
//  UsersTableViewController.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: Users Table View Controller

/**
    `UsersTableViewController`

    A view controller used to list the users.
 */
class UsersTableViewController: UITableViewController {

    //	MARK: Properties
    
    /// Create the object which will be used to load the users. Needs to be variable by the nature of loading the users.
    var users = [User]()
    
    //	MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            fatalError("There is an unexpected segue without an identifier in UsersTableViewController: \(segue).")
        }
        
        switch segueIdentifier {
        case String(UserDetailViewController):
            guard let userDetailVC = segue.destinationViewController as? UserDetailViewController else { fatalError("Incorrect view controller for the segue \"\(String(UserDetailViewController))\".") }
            let selectedUser = users[tableView.indexPathForSelectedRow!.row]
            userDetailVC.user = selectedUser
        default:
            fatalError("There is an unexpected segue with the identifier \"\(segueIdentifier)\" in UsersTableViewController.")
        }
    }
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        PicShareResource<User>.allUsers() { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
}

extension UsersTableViewController {
    
    //	MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath) as? UserTableViewCell else {
            fatalError("The correct cell was not dequeued for table view: \(tableView)")
        }
        
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.catchPhraseLabel.text = user.company.catchPhrase
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}