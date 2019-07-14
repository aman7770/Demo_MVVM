//
//  Util.swift
//  HarmonTask
//
//  Created by apple on 9/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreLocation

public class Reachability {
    
    class func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
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
        let isReachableNetwork = (isReachable && !needsConnection)
        return isReachableNetwork
    }
}

// Converts Coordinate to String
extension CLLocationCoordinate2D {
    func toString() -> (latitude: String, longitude: String) {
        return (String(self.latitude), String(self.longitude))
    }
}




