//
//  PicShareObjects.swift
//  PicShare
//
//  Created by James Valaitis on 26/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import CoreLocation
import Foundation

//	MARK: User

/**
    `User`

    Object that represents a user.
 */
struct User: JSONInitializable {
    
    //	MARK: Address
    
    struct Address {
        /**
         Keys that can be used on an address to access pieces of address information.
         */
        private enum AddressJSONKey: String {
            /// A key to get the street of the address.
            case Street = "street"
            /// A key to get the suite number.
            case Suite = "suite"
            /// A key to get the city of the address.
            case City = "city"
            /// A key to get the zip code of the address.
            case ZipCode = "zipcode"
            /// A key to get the co-ordinates that locate the address.
            case Coordinates = "geo"
        }
        
        //	MARK: Properties
        
        /// The street of the address.
        let street: String?
        /// The suite number.
        let suite: String?
        /// The city of the address.
        let city: String?
        /// The zip code for the address.
        let zipCode: String?
        /// The co-ordinates that locate the address.
        let coordinates: CLLocationCoordinate2D?
        
        //	MARK: Initialisation
        
        /**
        Initialises an address with a given JSON representation.
        */
        init?(JSON: JSONValue) {
            for (key, _) in JSON {
                guard let _ = AddressJSONKey(rawValue: key) else {
                    print("Invalid JSON representation of Address: \(JSON)")
                    return nil
                }
            }
            
            city = JSON[AddressJSONKey.City.rawValue] as? String
            
            if let coordinatesMap = JSON[AddressJSONKey.Coordinates.rawValue] as? JSONValue, latitude = coordinatesMap["latitude"] as? CLLocationDegrees, longitude = coordinatesMap["longitude"] as? CLLocationDegrees {
                coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                coordinates = nil
            }
            
            street = JSON[AddressJSONKey.Street.rawValue] as? String
            suite = JSON[AddressJSONKey.Suite.rawValue] as? String
            zipCode = JSON[AddressJSONKey.ZipCode.rawValue] as? String
        }
    }
    
    //	MARK: Company
    struct Company {
        //	MARK: Company Keys
        
        /**
        Keys that can be used on a company to get pieces of company information.
        */
        private enum CompanyJSONKey: String {
            /// The key to get the not boring name of the company.
            case Name = "name"
            /// The key to get the catchy one liner that sums a company up perfectly. Right?
            case CatchPhrase = "catchPhrase"
            /// Arguably the most import part of the company.
            case Bull = "bs"
        }
        
        //	MARK: Properties
        
        /// The very 'dynamic' name of this 'ground-breaking' company.
        let name: String
        /// The amazing catch phrase that represents how this company is making waves in the industry.
        let catchPhrase: String
        /// Gotta have it.
        let bull: String
        
        //	MARK: Initialisation
        
        /**
        Initialises a company with a given JSON representation.
        */
        init?(JSON: JSONValue) {
            for (key, _) in JSON {
                guard let _ = CompanyJSONKey(rawValue: key) else {
                    print("Invalid JSON representation of Company: \(JSON)")
                    return nil
                }
            }
            
            guard let companyName = JSON[CompanyJSONKey.Name.rawValue] as? String,
                companyCatchPhrase = JSON[CompanyJSONKey.CatchPhrase.rawValue] as? String,
                companyBull = JSON[CompanyJSONKey.Bull.rawValue] as? String else {
                    print("Invalid JSON representation of Company: \(JSON)")
                    return nil
            }
            
            name = companyName
            catchPhrase = companyCatchPhrase
            bull = companyBull
        }
    }
    
    //	MARK: Properties
    
    /// The unique identifier for the user.
    let identifier: Identifier
    /// Name of the user.
    let name: String
    /// Username for the user.
    let username: String
    /// Email address for the user.
    let email: String
    /// The address of the user.
    let address: Address?
    /// The phone number for the user.
    let phone: String?
    /// The website for the user.
    let website: String?
    /// The user's company.
    let company: Company
    
    //	MARK: Initialisation
    
    /**
    Initialises a user with a given JSON representation.
    */
    init?(JSON: JSONValue) {
        guard let id = JSON["id"] as? Identifier,
            name = JSON["name"] as? String,
            username = JSON["username"] as? String,
            email = JSON["email"] as? String,
            companyJSON = JSON["company"] as? JSONValue,
            company = Company(JSON: companyJSON) else {
                print("User requires an identifier, name, user name, email, and company.")
                return nil
        }
        
        identifier = id
        self.name = name
        self.username = username
        self.email = email
        self.company = company
        phone = JSON["phone"] as? String
        website = JSON["website"] as? String

        if let addressJSON = JSON["address"] as? JSONValue {
            address = Address(JSON: addressJSON)
        } else {
            address = nil
        }
    }
}

//	MARK: StringRepresentable

extension User: StringRepresentable {
    var shortString: String { return name }
    var mediumString: String { return name + " (" + email + ") - " + company.catchPhrase }
    var longString: String { return name + " (" + email + ") - " + company.catchPhrase }
}