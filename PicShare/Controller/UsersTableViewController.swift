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
    
    /// Create the object which will be used to load the users.
    let users = Users()
    
    //	MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}