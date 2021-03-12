//
//  HomeTarget.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import Moya

internal enum HomeTarget {
    case getHomeDeveloperList
    case getHomeTopRatedGames
}

extension HomeTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.rawg.io/")!
    }
    
    var path: String {
        switch self {
        case .getHomeDeveloperList:
            return "api/developers"
        case .getHomeTopRatedGames:
            return "api/games"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getHomeDeveloperList:
            return [
                "key": "7aeec70b17574b5089ad68144d1e8a87",
                "page_size": 10
            ]
        case .getHomeTopRatedGames:
            return [
                "key": "7aeec70b17574b5089ad68144d1e8a87",
                "page_size": 10,
                "ordering": "-rating"
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    var sampleData: Data {
        return "{\"data\": 123}".data(using: .utf8)!
    }
}
