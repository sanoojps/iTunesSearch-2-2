//
//  ConfigurationTests.swift
//  iTunesSearchTests
//
//  Created by Sanooj on 20/08/2018.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class ConfigurationTests: XCTestCase {
    
    var searchBaseURL: String! 
    var searchEndPoint: String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        searchBaseURL = "https://itunes.apple.com"
        searchEndPoint = "/search"
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        searchBaseURL = nil
        searchEndPoint = nil
    }
    

}


extension ConfigurationTests
{
    func testSearchEndPointWithValidSearchTerm()
    {
        let searchterm = "Green day"
        
        let endPoint =
        SearchEndpoint.fetchResults(searchterm)
        
        XCTAssertTrue(endPoint.queryItems.count > 0)
    }
    
    func testSearchEndPointWithInValidSearchTerm()
    {
        let searchterm = " "
        
        let endPoint =
            SearchEndpoint.fetchResults(searchterm)
        
        XCTAssertNotNil(endPoint.urlComponent?.url)
    }
    
    func testSearchEndPointReturnsValkidBaseURL()
    {
        let searchterm = "Green day"
        
        let endPoint =
            SearchEndpoint.fetchResults(searchterm)
        
        XCTAssertTrue(endPoint.baseUrl == searchBaseURL)
    }
    
    func testSearchEndPointReturnsValkidEndPoint()
    {
        let searchterm = "Green day"
        
        let endPoint =
            SearchEndpoint.fetchResults(searchterm)
        
        XCTAssertTrue(endPoint.path == searchEndPoint)
    }
}
