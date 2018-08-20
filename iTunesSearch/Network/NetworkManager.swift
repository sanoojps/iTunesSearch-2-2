//
//  NetworkManager.swift
//  iTunesSearch
//
//  Created by Maddiee on 19/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import Foundation
import UIKit

// MARK: -  Request Completion Handlers
typealias QueryResult = (Base?, Error?) -> Void
typealias ImageResult = (UIImage?, URL, Error?) -> Void

/// Network Interactions Manager
///
/// Handles HTTP Network Requests
///

class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    private init() {}
    
    private let defaultSession = URLSession(configuration: .default)
    private(set) var allDataTasks = [URLSessionTask]()
    private(set) var allDownloadTasks = [URLSessionTask]()
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        
        guard Reachability.isConnectedToNetwork() else {
            let error = Constants.Errors.NetworkErrors.NoNetwork.error
            completion(nil,error)
            return
        }
        
        // cancel already added task as search query has changed
        allDataTasks.forEach({$0.cancel()})
        
        // sanity check for endpoint
        guard let url = SearchEndpoint.fetchResults(searchTerm).urlComponent?.url else {
            let error = Constants.Errors.Default.error
            completion(nil,error)
            return
        }
        
        // create task
        let task = createADataTask(url, completion)
        
        // start the task
        self.allDataTasks.append(task)
        task.resume()
    }
    
    //MARK:- Image Download
    func downloadImage(url: URL, completion: @escaping ImageResult) {
        if let cachedImage = Utils.imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, url, nil)
        } else {
            
            guard Reachability.isConnectedToNetwork() else {
                let error = Constants.Errors.NetworkErrors.NoNetwork.error
                completion(nil, url, error)
                return
            }
            
            let task = createADownloadTask(url, completion)
            task.resume()
            allDownloadTasks.append(task)
        }
    }
    
    func cancelDownloadingImage(forURL url: String) {
        // Find a task with given URL, cancel it and delete from `tasks` array.
        
        guard let taskIndex = allDownloadTasks.index(where: { $0.originalRequest?.url == URL(string: url)! }) else {
            return
        }
        let task = allDownloadTasks[taskIndex]
        task.cancel()
        allDownloadTasks.remove(at: taskIndex)
    }
}

//MARK: - Task Creation Helper Functions
fileprivate extension NetworkManager
{
    fileprivate func handleDownloadTaskResponse(_ data: Data?,url:URL, completion: @escaping ImageResult) {
        // Perform UI changes only on main thread.
        DispatchQueue.main.async {
            if let data = data, let image = UIImage(data: data) {
                Utils.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image, url, nil)
            } else {
                let error =
                    Constants.Errors.NetworkErrors.NoNetwork.error
                completion(nil, url, error)
            }
        }
    }
    
    fileprivate func createADownloadTask(_ url: URL, _ completion: @escaping ImageResult) -> URLSessionDataTask {
        return defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleDownloadTaskResponse(data, url: url, completion: completion)
        }
    }
    
    fileprivate func handleDataTaskResponse(_ error: Error?, _ data: Data?, _ response: URLResponse?, _ completion: @escaping QueryResult) {
        if let error = error {
            print( "DataTask error: " + error.localizedDescription + "\n")
            completion(nil,error)
        } else if let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            let model = try? JSONDecoder().decode(Base.self, from: data)
            DispatchQueue.main.async {
                completion(model, nil)
            }
        }
        else {
            let error = Constants.Errors.NetworkErrors.NoNetwork.error
            completion(nil,error)
        }
    }
    
    fileprivate func createADataTask(_ url: URL, _ completion: @escaping QueryResult) -> URLSessionDataTask {
        return defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleDataTaskResponse(error, data, response, completion)
        }
    }
}
