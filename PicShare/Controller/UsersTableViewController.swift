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
    
    private let searchController = UISearchController(searchResultsController: nil)
    /// Create the object which will be used to load the users. Needs to be variable by the nature of loading the users.
    var users = [User]() {
        didSet {
            filteredUsers = users
        }
    }
    private var filteredUsers = [User]()
    
    //	MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            fatalError("There is an unexpected segue without an identifier in UsersTableViewController: \(segue).")
        }
        
        switch segueIdentifier {
        case String(UserDetailViewController):
            guard let userDetailVC = segue.destinationViewController as? UserDetailViewController else { fatalError("Incorrect view controller for the segue \"\(String(UserDetailViewController))\".") }
            let selectedUser = filteredUsers[tableView.indexPathForSelectedRow!.row]
            userDetailVC.user = selectedUser
        default:
            fatalError("There is an unexpected segue with the identifier \"\(segueIdentifier)\" in UsersTableViewController.")
        }
    }
    
    //	MARK: Filtering
    
    private func filteredUsersForSearchTerm(searchTerm: String) -> [User] {
        
        guard searchTerm != "" else { return users }
        
        let filteredUsers = users.filter { $0.name.lowercaseString.containsString(searchTerm.lowercaseString) }
        return filteredUsers
    }
    
    //	MARK: View Lifecycle
    
    override func viewDidLoad() {
        
        tableView.accessibilityIdentifier = "Users"
        
        PicShareResource<User>.allUsers() { users in
            self.users = users
            self.tableView.reloadData()
        }
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

//	MARK: UITableViewDataSource

extension UsersTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath) as? UserTableViewCell else {
            fatalError("The correct cell was not dequeued for table view: \(tableView)")
        }
        
        let user = filteredUsers[indexPath.row]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.catchPhraseLabel.text = user.company.catchPhrase
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
}

extension UsersTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(searchController: UISearchController) {
        filteredUsers = users
        tableView.reloadData()
    }
}

//	MARK: UISearchResultsUpdating

extension UsersTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredUsers = filteredUsersForSearchTerm(searchController.searchBar.text!)
        tableView.reloadData()
    }
}