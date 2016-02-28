//
//  UserTableViewCell.swift
//  PicShare
//
//  Created by James Valaitis on 28/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: User Table View Cell

/**
    `UserTableViewCell`

    In a table view this cell will represent a user.
 */
class UserTableViewCell: UITableViewCell {
    
    //	MARK: Properties
    
    /// A label used to display the user as a string.
    @IBOutlet var userTitleLabel: UILabel!
    
    //	MARK: StringDisplay
    
    override var containerSize: CGSize { return userTitleLabel.frame.size }
    override var containerFont: UIFont { return userTitleLabel.font }
    
    override func assignString(string: String) {
        userTitleLabel.text = string
    }
}