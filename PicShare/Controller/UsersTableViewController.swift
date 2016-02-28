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
    var users = Users()
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        users.loadJSON()
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
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.users.count
    }
}