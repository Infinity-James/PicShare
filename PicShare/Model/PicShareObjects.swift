//
//  PicShareObjects.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import Foundation

//	MARK: Address Keys

/**
    Keys that can be used on an address to access pieces of address information.
 */
enum AddressKey: String {
    /// The street of the address.
    case Street = "street"
    /// The suite number.
    case Suite = "suite"
    /// The city of the address.
    case City = "city"
    /// The xip code of the address.
    case ZipCode = "zipcode"
    /// Co-ordinates that locate the address.
    case Coordinates = "geo"
}
/// A type that defines a dictionary describing an address.
typealias Address = [AddressKey: String]

//	MARK: Company Keys

/**
    Keys that can be used on a company to get pieces of company information.
 */
enum CompanyKey: String {
    /// The not boring name of the company.
    case Name = "name"
    /// The catchy one liner that sums a company up perfectly. Right?
    case CatchPhrase = "catchphrase"
    /// Arguably the most import part of the company.
    case Bull = "bs"
}
/// A type that defines a dictionary describing a company.
typealias Company = [CompanyKey: String]

//	MARK: User

/**
    `User`
 
    Object that represents a user.
 */
class User: NSObject {
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}