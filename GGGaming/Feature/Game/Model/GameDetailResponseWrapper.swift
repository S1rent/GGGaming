//
//  GameDetailResponseWrapper.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation

public struct GameDetailResponseWrapper: Decodable {
    let gameID: Int?
    let gameName: String?
    let gameDescription: String?
    let gameReleaseDate: String?
    let gameImagePreview: String?
    let gameAdditionalImagePreview: String?
    let gameRating: Double?
    let developers: [Developer]?
    
    internal enum CodingKeys: String, CodingKey {
        case gameID = "id"
        case gameName = "name"
        case gameDescription = "description"
        case gameReleaseDate = "released"
        case gameImagePreview = "background_image"
        case gameAdditionalImagePreview = "background_image_additional"
        case gameRating = "rating"
        case developers = "developers"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.gameID = try values.decode(Int.self, forKey: .gameID)
        self.gameName = try values.decode(String.self, forKey: .gameName)
        self.gameDescription = try values.decode(String.self, forKey: .gameDescription)
        self.gameReleaseDate = try values.decode(String.self, forKey: .gameReleaseDate)
        self.gameImagePreview = try values.decode(String.self, forKey: .gameImagePreview)
        self.gameAdditionalImagePreview = try values.decode(String.self, forKey: .gameAdditionalImagePreview)
        self.gameRating = try values.decode(Double.self, forKey: .gameRating)
        self.developers = try values.decode([Developer].self, forKey: .developers)
    }
}
