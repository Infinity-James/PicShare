//
//  DataFormatting.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

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

extension StringRepresentable where Self: User {
    var shortString: String { return name }
    var mediumString: String { return name + " (" + email + ") - " + company.catchPhrase }
    var longString: String { return name + " (" + email + ") - " + company.catchPhrase }
}