//
//  HomeNetworkProvider.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class HomeNetworkProvider {

    let provider = MoyaProvider<HomeTarget>()
    public static let shared = HomeNetworkProvider()
    
    private init() { }
    
    public func getHomeDeveloperList() -> Observable<[Developer]> {
        let requestToken = HomeTarget.getHomeDeveloperList
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(HomeDeveloperResponseWrapper.self)
            .map{ $0.data ?? [] }
            .asObservable()
    }
    
    public func getHomeTopRatedGames() -> Observable<[Game]> {
        let requestToken = HomeTarget.getHomeTopRatedGames
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(HomeGameResponseWrapper.self)
            .map{ $0.data ?? [] }
            .asObservable()
    }
}
