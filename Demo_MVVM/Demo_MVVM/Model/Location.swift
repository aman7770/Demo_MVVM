//
//  Location.swift

//
//  Created by apple on 9/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import CoreLocation

// Base Location
struct LocationBase : Decodable {
    let response : Response?
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(Response.self, forKey: .response)
    }
}

struct Response : Decodable {
    let view : [View]?
    
    enum CodingKeys: String, CodingKey {
        case metaInfo = "MetaInfo"
        case view = "View"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      //  metaInfo = try values.decodeIfPresent(MetaInfo.self, forKey: .MetaInfo)
        view = try values.decodeIfPresent([View].self, forKey: .view)
    }
}

// View
struct View : Decodable {
    let _type : String?
    let viewId : Int?
    let result : [Results]?
    
    enum CodingKeys: String, CodingKey {
        case _type = "_type"
        case viewIdentifier = "ViewId"
        case result = "Result"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _type = try values.decodeIfPresent(String.self, forKey: ._type)
        viewId = try values.decodeIfPresent(Int.self, forKey: .viewIdentifier)
        result = try values.decodeIfPresent([Results].self, forKey: .result)
    }
    
}

// Result..
struct Results : Decodable {
    let relevance : Double?
    let distance : Double?
    let matchLevel : String?
    let matchType : String?
    let location : LocationDetail?
    
    enum CodingKeys: String, CodingKey {
        
        case relevance = "Relevance"
        case distance = "Distance"
        case matchLevel = "MatchLevel"
        case matchType = "MatchType"
        case location = "Location"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        relevance = try values.decodeIfPresent(Double.self, forKey: .relevance)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        matchLevel = try values.decodeIfPresent(String.self, forKey: .matchLevel)
        matchType = try values.decodeIfPresent(String.self, forKey: .matchType)
        location = try values.decodeIfPresent(LocationDetail.self, forKey: .location)
    }
    
}

// Location Detail...
struct LocationDetail : Decodable {
    let locationId : String?
    let locationType : String?
    let address : Address?
   
    enum CodingKeys: String, CodingKey {
        case locationId = "LocationId"
        case locationType = "LocationType"
        case address = "Address"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        locationId = try values.decodeIfPresent(String.self, forKey: .locationId)
        locationType = try values.decodeIfPresent(String.self, forKey: .locationType)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
    }
}

// Address Model...
struct Address : Decodable {
    let label : String?
    let country : String?
    let state : String?
    let county : String?
    let city : String?
    let district : String?
    let street : String?
    let houseNumber : String?
    let postalCode : String?
    
    enum CodingKeys: String, CodingKey {
        case label = "Label"
        case country = "Country"
        case state = "State"
        case county = "County"
        case city = "City"
        case district = "District"
        case street = "Street"
        case houseNumber = "HouseNumber"
        case postalCode = "PostalCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        county = try values.decodeIfPresent(String.self, forKey: .county)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        district = try values.decodeIfPresent(String.self, forKey: .district)
        street = try values.decodeIfPresent(String.self, forKey: .street)
        houseNumber = try values.decodeIfPresent(String.self, forKey: .houseNumber)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
    }
}

// Location
public struct Location: Codable {
    let latitude: String?
    let longitude: String?
    let address: String?
}






