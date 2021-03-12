//
//  GameNetworkProvider.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class GameNetworkProvider {

    let provider = MoyaProvider<GameTarget>()
    public static let shared = GameNetworkProvider()
    
    private init() { }
    
    public func getGameDetail(with id: Int) -> Observable<GameDetailResponseWrapper> {
        let requestToken = GameTarget.getGameDetail(id: id)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(GameDetailResponseWrapper.self)
            .asObservable()
    }
}
