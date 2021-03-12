//
//  HomeGameResponseWrapper.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation

public struct HomeGameResponseWrapper: Decodable {
    let data: [Game]?
    
    internal enum CodingKeys: String, CodingKey {
        case data = "results"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decode([Game].self, forKey: .data)
    }
}

public struct Game: Decodable {
    let gameID: Int?
    let gameName: String?
    let gameImagePreview: String?
    let gameRating: Double?
    let gameReleaseDate: String?
    
    internal enum CodingKeys: String, CodingKey {
        case gameID = "id"
        case gameName = "name"
        case gameImagePreview = "background_image"
        case gameRating = "rating"
        case gameReleaseDate = "released"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.gameID = try values.decodeIfPresent(Int.self, forKey: .gameID)
        self.gameName = try values.decodeIfPresent(String.self, forKey: .gameName)
        self.gameImagePreview = try values.decodeIfPresent(String.self, forKey: .gameImagePreview)
        self.gameRating = try values.decodeIfPresent(Double.self, forKey: .gameRating)
        self.gameReleaseDate = try values.decodeIfPresent(String.self, forKey: .gameReleaseDate)
    }
}
