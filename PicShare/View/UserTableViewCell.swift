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
    
    /// A label used to display the user's name.
    @IBOutlet var nameLabel: UILabel!
    /// A label used to display the user's email address.
    @IBOutlet var emailLabel: UILabel!
    /// A label used to display the user's company's amazing catch phrase.
    @IBOutlet var catchPhraseLabel: UILabel!
    
    //	MARK: StringDisplay
    
    override var containerSize: CGSize { return nameLabel.frame.size }
    override var containerFont: UIFont { return nameLabel.font }
    
    override func assignString(string: String) {
        nameLabel.text = string
    }
}