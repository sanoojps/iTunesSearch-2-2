//
//  Router.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import Foundation


protocol Endpoint {
    var baseUrl: String {get}
    var path: String {get}
    var queryItems: [URLQueryItem] {get}
}

extension Endpoint {
    
    var urlComponent: URLComponents? {
        var component = URLComponents(string: baseUrl)
        component?.path = path
        component?.queryItems = queryItems
        return component
    }
}

enum SearchEndpoint: Endpoint {
    
    case fetchResults(String)
    
    var baseUrl: String {
        switch self {
        case .fetchResults(_):
            return Constants.APIComponents.URLEndpoints.searchBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .fetchResults(_):
            return Constants.APIComponents.URLEndpoints.searchEndPoint
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchResults(let value):
            let queryParam = URLQueryItem(name: Constants.APIComponents.URLQueryParamterKeys.term, value: value)
            return [queryParam]
        }
    }
}
