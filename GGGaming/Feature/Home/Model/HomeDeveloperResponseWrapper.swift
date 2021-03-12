//
//  HomeResponseWrapper.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation

public struct HomeDeveloperResponseWrapper: Decodable {
    let data: [Developer]?
    
    internal enum CodingKeys: String, CodingKey {
        case data = "results"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decode([Developer].self, forKey: .data)
    }
}

public struct Developer: Decodable {
    let developerID: Int?
    let developerName: String?
    let developerImagePreview: String?
    
    internal enum CodingKeys: String, CodingKey {
        case developerID = "id"
        case developerName = "name"
        case developerImagePreview = "image_background"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.developerID = try values.decodeIfPresent(Int.self, forKey: .developerID)
        self.developerName = try values.decodeIfPresent(String.self, forKey: .developerName)
        self.developerImagePreview = try values.decodeIfPresent(String.self, forKey: .developerImagePreview)
    }
}
