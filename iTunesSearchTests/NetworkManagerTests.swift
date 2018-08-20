//
//  NetworkManagerTests.swift
//  iTunesSearchTests
//
//  Created by Sanooj on 20/08/2018.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var networkTimeOut:TimeInterval!
    var networkRequestExpectation: XCTestExpectation!
    
    var imageURLString: String!
    var malformedSearchTerm: String!
    var validSearchQuery: String!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.networkManager =
            NetworkManager.shared
        
        self.networkTimeOut = 60.0
        
        self.networkRequestExpectation =
            XCTestExpectation.init(description: "NetworkRequestEcpectation")
        
        self.imageURLString =
        "https://cdn.dribbble.com/users/35541/screenshots/1060855/player.png"
        
        self.validSearchQuery = "https://itunes.apple.com/search?term=green&limit=2"
        
        self.malformedSearchTerm =
        "://"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        self.networkManager = nil
        
        self.networkTimeOut = nil
        
        self.networkRequestExpectation = nil
        
        self.imageURLString = nil
        
        self.malformedSearchTerm = nil
        
        self.validSearchQuery = nil
    }
    
}

// MARK: GetSearchResult
extension NetworkManagerTests
{
    func testGetSearchResultsReturnsResponseWithMalformedSearchTerm()
    {
        self.networkManager.getSearchResults(searchTerm: malformedSearchTerm) { (response:Base?, error:Error?) in
    
            XCTAssertNotNil(response, "Should return a valid response.Should not be nil")
            
            self.networkRequestExpectation.fulfill()
        
        }
        
        wait(for: [networkRequestExpectation], timeout: self.networkTimeOut)
    }
    
     func testGetSearchResultsReturnsEmptyResponseWithMalformedSearchTerm()
     {
        
        self.networkManager.getSearchResults(searchTerm: malformedSearchTerm) { (response:Base?, error:Error?) in
            
            XCTAssert(response?.resultCount == 0,"Should return a count of 0")
            
            self.networkRequestExpectation.fulfill()
        }
        
         wait(for: [self.networkRequestExpectation], timeout: self.networkTimeOut)
    }
    
    func testGetSearchResultsReturnsResponseWithValidSearchTerm()
    {
        let validSearchTerm =
        "Green Day"
        
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
            
            XCTAssert(response?.resultCount != 0,"Should not return a count of 0")
            
            self.networkRequestExpectation.fulfill()
        }
        
        wait(for: [self.networkRequestExpectation], timeout: self.networkTimeOut)
    }
    
    func testGetSearchResultsClearsUrlSessionTasksAfterCreationForValidSearchTerm()
    {
        let validSearchTerm =
        "Green Day"
        
        // first task
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
        
        }
        
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
            
        }
        
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
            
        }
        
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
            
        }
        
        //second task
        self.networkManager.getSearchResults(searchTerm: validSearchTerm) { (response:Base?, error:Error?) in
        
            self.networkRequestExpectation.fulfill()
        }
        
        let stateOftask:URLSessionTask.State? = ((self.networkManager.allDataTasks[3]).state)
        
        //first task should be cancelled
        XCTAssertTrue(stateOftask == .canceling ,"Should be true")
        
        wait(for: [self.networkRequestExpectation], timeout: 30)
    }
}

// MARK: downloadImage
extension NetworkManagerTests
{
    func testDownloadImageReturnsErrorWithMalformedURL()
    {
        let malFormedURL: URL! =
            URL.init(string: "https://com")
        
        self.networkManager.downloadImage(url: malFormedURL) { (image:UIImage?, url:URL?, error:Error?) in
            
            XCTAssertNotNil(error, "Should return an error")
            
            self.networkRequestExpectation?.fulfill()
            
        }
        
        wait(for: [self.networkRequestExpectation], timeout: 120)
    }
    
    func testDownloadImageReturnsImageWithValidURL()
    {
        let validURL: URL! =
            URL.init(string: self.imageURLString)
        
        self.networkManager.downloadImage(url: validURL) { (image:UIImage?, url:URL?, error:Error?) in
            
            XCTAssertNotNil(image, "Should return an error")
            
            self.networkRequestExpectation?.fulfill()
            
        }
        
        wait(for: [self.networkRequestExpectation], timeout: 120)
    }
    
    func testDownloadImageReturnsCachedImageSecondTimeWithValidURL()
    {
        let validURL: URL! =
            URL.init(string: self.imageURLString)
        
        // first request
        self.networkManager.downloadImage(url: validURL) { (image:UIImage?, url:URL?, error:Error?) in

            self.networkRequestExpectation?.fulfill()
            
        }
        
        //second request with same url
        let localExpectation = XCTestExpectation(description: "SubsequentNetworkRequest")
        self.networkManager.downloadImage(url: validURL) { (image:UIImage?, url:URL?, error:Error?) in
            
            // check in cache
            let imageFromCache =
                Utils.imageCache.object(forKey: validURL.absoluteString as NSString)
            
            XCTAssertEqual(image, imageFromCache, "Should be equal")
            
            localExpectation.fulfill()
            
        }
        
        wait(for: [self.networkRequestExpectation,localExpectation], timeout: 120)
    }
    
    func testDownloadImageURLSessionTaskAvailableForValidURL()
    {
        let validURL: URL! =
            URL.init(string: self.imageURLString)
        
        // first request
        self.networkManager.downloadImage(url: validURL) { (image:UIImage?, url:URL?, error:Error?) in
            
        }
        
        let taskIndex =
            self.networkManager.allDownloadTasks.index(where: { $0.originalRequest?.url == validURL })
        
        XCTAssertNotNil(taskIndex, "Should return a valid index")
    }
}


// MARK: cancelDownloadingImage
extension NetworkManagerTests
{
    func testCancelDownloadingImageWithValidURL()
    {
        let validURL: URL! =
            URL.init(string: self.imageURLString)

        // first request
        self.networkManager.downloadImage(url: validURL) { (image:UIImage?, url:URL?, error:Error?) in

        }
        
        self.networkManager.cancelDownloadingImage(forURL: validURL.absoluteString)

        let taskIndex =
            self.networkManager.allDownloadTasks.index(where: { $0.originalRequest?.url == validURL })

        XCTAssertNil(taskIndex, "Should return nil")
    }
    
    func testCancelDownloadingImageMalformedURLString()
    {
        let malFormedURLString: String = ""
        
        let malFormedURL: URL? =
            URL.init(string: malFormedURLString)
        
        self.networkManager.cancelDownloadingImage(forURL: malFormedURLString)
        
        let taskIndex =
            self.networkManager.allDownloadTasks.index(where: { $0.originalRequest?.url == malFormedURL })
        
        XCTAssertNil(taskIndex, "Should return nil")
    }
    
}
