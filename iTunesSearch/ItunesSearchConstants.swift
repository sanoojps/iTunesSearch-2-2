//
//  ItunesSearchConstants.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import Foundation

let kTrackName = "trackName"
let kArtistName = "artistName"
let kCollectionName = "collectionName"
let kTrackPrice = "trackPrice"
let kReleaseDate = "releaseDate"
let kMainNavbarTitle = "mainNavBarTitle"
let kDetailsNavBarTitle = "detailsNavBarTitle"

struct Constants
{
    private init() {}
    
}

// MARK: - APIComponents

extension Constants
{
    struct APIComponents
    {
        private init() {}
        
        struct URLEndpoints
        {
            private init() {}
            
            static let searchBaseURL = "https://itunes.apple.com"
            
            static let searchEndPoint = "/search"
            
        }
        
        struct URLQueryParamterKeys
        {
            private init() {}
            
            static let term = "term"
        }
        
    }
}

// MARK: - Error description keys
protocol ErrorDescriptionKeys
{
    static var errorCode:Int {get}
    static var errorDesciption:String {get}
    static var errorDisplayString:String {get}
    static var error: NSError {get}
}

extension Constants
{
    struct Errors
    {
        private init() {}
        
        static let domian = "com.md.itunes.search.trial.error"
        
        struct Default:ErrorDescriptionKeys
        {
            static let errorCode = 99989
            static let errorDesciption = ""
            static let errorDisplayString =
            "Failed to load resource.Unknown Error."
            static let error: NSError  =
                NSError(
                    domain: Constants.Errors.domian,
                    code: Constants.Errors.Default.errorCode,
                    userInfo: [
                        NSLocalizedDescriptionKey :
                            Constants.Errors.Default.errorDisplayString
                    ]
            )
            
            
            
        }
        
        struct NetworkErrors
        {
            private init() {}
            
            struct NoNetwork:ErrorDescriptionKeys
            {
                private init() {}
                
                static let errorCode = 99988
                static let errorDesciption = ""
                static let errorDisplayString =
                "Failed to load resource.Please check your network connection and try again"
                
                static let error: NSError =
                    NSError(
                        domain: Constants.Errors.domian,
                        code: Constants.Errors.NetworkErrors.NoNetwork.errorCode,
                        userInfo: [
                            NSLocalizedDescriptionKey :
                                Constants.Errors.NetworkErrors.NoNetwork.errorDisplayString
                        ]
                )
            }
            
        }
    }
}
