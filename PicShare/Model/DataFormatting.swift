//
//  DataFormatting.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import UIKit

//	MARK: String Representable

/**
    `StringRepresentable`

    A protocol that defines conforming object a representable as a String.
 */
protocol StringRepresentable {
    /// A short version of the string representation of the object.
    var shortString: String { get }
    /// A medium version of the string representation of the object.
    var mediumString: String { get }
    /// A long version of the string representation of the object.
    var longString: String { get }
}

extension NSObjectProtocol where Self: StringRepresentable {
    /// Automatically implement description for objects that can be represented as strings.
    var description: String { return longString }
}

//	MARK: String Display

/**
    `StringDisplay`

    A protocol to declare how best to display an item based on a given UI scenario.
 */
protocol StringDisplay {
    /// The size of our container that we would display a string in.
    var containerSize: CGSize { get }
    /// The font for the string that we would display.
    var containerFont: UIFont { get }
    /**
        When passed a string the asopter of this protocol should display the given string.
     
        - Parameter string:     The string to be displayed by the adopter of this protocol.
     */
    func assignString(string: String)
}

extension StringDisplay {
    /**
        Displays a string value given a string representable object.
     
        - Parameter object:     The object to be displayed as a string by us.
     */
    func displayStringValue(object: StringRepresentable) {
        //  determine the longest string which can fit within our size
        if stringWithin(object.longString) { assignString(object.longString) }
        else if stringWithin(object.mediumString) { assignString(object.mediumString) }
        else { assignString(object.shortString) }
    }
    
    /**
        Returns an ideal size based on the container size and string.
     
        - Parameter string:     The string to create a size for.
     
        - Returns:  The size for the given string and our container size.
     */
    func sizeWithString(string: String) -> CGSize {
        let string = string as NSString
        let maxSize = CGSize(width: containerSize.width, height: .max)
        let attributes = [NSFontAttributeName: containerFont]
        let frame = string.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return frame.size
    }
    
    /**
        Returns whether a given string can fit within our container size.
     
        - Returns:  `true` if the string can git within our container, `false` otherwise.
     */
    private func stringWithin(string: String) -> Bool {
        let requiredHeight = sizeWithString(string).height
        let allowedHeight = containerSize.height
        return requiredHeight <= allowedHeight
    }
}

extension UILabel: StringDisplay {
    var containerSize: CGSize { return frame.size }
    var containerFont: UIFont { return font }
    func assignString(string: String) {
        text = string
    }
}

extension UITableViewCell: StringDisplay {
    var containerSize: CGSize { return textLabel!.frame.size }
    var containerFont: UIFont { return textLabel!.font }
    func assignString(string: String) {
        textLabel!.text = string
    }
}

extension UIButton: StringDisplay {
    var containerSize: CGSize { return frame.size }
    var containerFont: UIFont { return titleLabel!.font }
    func assignString(string: String) {
        setTitle(string, forState: .Normal)
    }
}

extension UIViewController: StringDisplay {
    var containerSize: CGSize { return navigationController!.navigationBar.frame.size }
    var containerFont: UIFont { return .systemFontOfSize(34.0) }
    func assignString(string: String) {
        title = string
    }
}