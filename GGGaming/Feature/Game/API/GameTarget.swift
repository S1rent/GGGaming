//
//  GameTarget.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import Moya

internal enum GameTarget {
    case getGameDetail(id: Int)
    case getGameListByDeveloperID(id: Int)
}

extension GameTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.rawg.io/")!
    }
    
    var path: String {
        switch self {
        case let .getGameDetail(id):
            return "api/games/\(id)"
        case .getGameListByDeveloperID:
            return "api/games"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getGameDetail:
            return [
                "key": "7aeec70b17574b5089ad68144d1e8a87"
            ]
        case let .getGameListByDeveloperID(id):
            return [
                "key": "7aeec70b17574b5089ad68144d1e8a87",
                "developers": id,
                "page_size": 20
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
