//
//  Utils.swift
//  iTunesSearch
//
//  Created by Maddiee on 18/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

enum TrackDetails {
    case trackName
    case albumName
}

struct Utils {
    
    static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 50
        return cache
    }()
    
    
    static func getDateString(_ dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        return  dateFormatter.string(from: date)
    }
}

// MARK:- Reachability
typealias Reachability = Utils
extension Utils
{
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress =
            sockaddr_in(
                sin_len: 0,
                sin_family: 0,
                sin_port: 0,
                sin_addr: in_addr(s_addr: 0),
                sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

// MARK:- View Configuration
extension Utils
{
    struct ViewConfigurations
    {
        // configure initial view appearance
        static func configure<View:UIView>(
            view: View? ,
            withCornerRadius cornerRadius:CGFloat,
            borderWidth:CGFloat = 4.0,
            andColor color: UIColor = UIColor.white
            )
            
        {
            view?.layer.cornerRadius =  cornerRadius
            view?.clipsToBounds = true
            view?.layer.borderWidth = borderWidth
            view?.layer.borderColor = color.cgColor
        }
    }
}

// MARK:- Model Serialization
extension Utils
{
    static func getDetailModelFromMasterModel(_ model: Results) -> [DetailsViewModel] {
        
        let albumName = DetailsViewModel(key: kCollectionName.localized, value: model.collectionName ?? "")
        let trackName = DetailsViewModel(key: kTrackName.localized, value: model.trackName ?? "")
        let artisName = DetailsViewModel(key: kArtistName.localized, value: model.artistName ?? "")
        let releaseDate = DetailsViewModel(key: kReleaseDate.localized, value: Utils.getDateString(model.releaseDate ?? ""))
        let trackPrice = DetailsViewModel(key: kTrackPrice.localized, value: "$ \(model.trackPrice ?? 0.0)")
        
        return [albumName, trackName, artisName, releaseDate, trackPrice]
    }
}


