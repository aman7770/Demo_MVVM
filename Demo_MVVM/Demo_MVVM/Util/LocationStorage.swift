//
//  LocationStorage.swift
//  HarmonTask
//
//  Created by apple on 9/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

// Protocol LocationStorage
public protocol LocationStorage {
    func storeLocation(forKey: String, address: Location)
    func retriveLocation(forKey: String) -> Location?
}

// Protocol Extension
extension LocationStorage {
    // Storage
    public func storeLocation(forKey: String, address: Location) {
        let encodedData = try? JSONEncoder().encode(address)
        UserDefaults.standard.set(encodedData, forKey: "Location")
        UserDefaults.standard.synchronize()
    }
    
    // Retrive Location
    public func retriveLocation(forKey: String) -> Location? {
        let decoder  = UserDefaults.standard.data(forKey: "Location")
        if let decoded = try? JSONDecoder().decode(Location.self, from: decoder!)  {
            return decoded
        }
        return nil
    }
}

