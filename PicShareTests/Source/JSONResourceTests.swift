//
//  PicShareTests.swift
//  PicShareTests
//
//  Created by James Valaitis on 25/02/2016.
//  Copyright © 2016 &Beyond. All rights reserved.
//

import XCTest
@testable import PicShare

//	MARK: JSON Resource Tests

class JSONResourceTests: XCTestCase {
    
    //	MARK: Constants
    
    /// We allow 5 seconds for each fetch.
    private let resourceFetchTimeout = 5.0
    
    //	MARK: Set Up
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //	MARK: Tests
    
    func testResourceURL() {
        
        let expectedHost = NSURL(string:"http://jsonplaceholder.typicode.com")!
        
        //  test if the user path ends up correct
        let usersPath = "users/"
        let expectedUsersURL = expectedHost.URLByAppendingPathComponent(usersPath)
        let users = PicShareResource<User>(JSONPath: usersPath)
        XCTAssertEqual(users.JSONURL, expectedUsersURL.absoluteString)
        
        //  test if the photo albums path ends up correct
        let photoAlbumsPath = "photoAlbums/"
        let expectedPhotoAlbumsURL = expectedHost.URLByAppendingPathComponent(photoAlbumsPath)
        let photoAlbums = PicShareResource<PhotoAlbum>(JSONPath: photoAlbumsPath)
        XCTAssertEqual(photoAlbums.JSONURL, expectedPhotoAlbumsURL.absoluteString)
    }
    
    func testFetchOfUsers() {
        let expectation = expectationWithDescription("Fetch of users.")
        
        PicShareResource<User>.allUsers { users in
            if users.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail("Users were not correctly fetched.")
            }
        }
        
        waitForExpectationsWithTimeout(resourceFetchTimeout) { error in
            print("Failed to fetch users: \(error)")
        }
    }


    func testFetchOfPhotoAlbums() {
        let expectation = expectationWithDescription("Fetch of photo albums.")
        
        PicShareResource<PhotoAlbum>.allPhotoAlbums { photoAlbums in
            if photoAlbums.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail("Photo albums were not correctly fetched.")
            }
        }
        
        waitForExpectationsWithTimeout(resourceFetchTimeout) { error in
            print("Failed to fetch photo albums: \(error)")
        }
    }
    
    func testFetchOfPhotos() {
        let expectation = expectationWithDescription("Fetch of photos.")
        
        PicShareResource<Photo>.allPhotos { photos in
            if photos.count > 0 {
                expectation.fulfill()
            } else {
                XCTFail("Photos were not correctly fetched.")
            }
        }
        
        waitForExpectationsWithTimeout(resourceFetchTimeout) { error in
            print("Failed to fetch photos: \(error)")
        }
    }
}