//
//  HomeViewModel.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let developerData: Driver<[Developer]>
        let gameData: Driver<[Game]>
        let loading: Driver<Bool>
        let developerNoData: Driver<Bool>
        let gameNoData: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let developerData = input.loadTrigger.flatMapLatest { _ -> Driver<[Developer]> in
            
            return HomeNetworkProvider.shared
                .getHomeDeveloperList()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let gameData = input.loadTrigger.flatMapLatest { _ -> Driver<[Game]> in
            
            return HomeNetworkProvider.shared
                .getHomeTopRatedGames()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let developerNoData = developerData.map { !($0.isEmpty) }
        
        let gameNoData = gameData.map { !($0.isEmpty) }
        
        return Output(
                developerData: developerData,
                gameData: gameData,
                loading: activityTracker.asDriver(),
                developerNoData: developerNoData,
                gameNoData: gameNoData
            )
    }
}
