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
        let gameData: Driver<[SectionModel<String, Any>]>
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
        
        let rawGameData = input.loadTrigger.flatMapLatest { _ -> Driver<[Game]> in
            
            return HomeNetworkProvider.shared
                .getHomeTopRatedGames()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let gameData = rawGameData.map { game -> [SectionModel<String, Any>] in
            var titleTopRated: String = ""
            var combinedArrays: [SectionModel<String,Any>] = []
            
            if !game.isEmpty {
                titleTopRated = "Top Rated Games"
            }
            
            if !game.isEmpty {
                combinedArrays.append(SectionModel(model: titleTopRated, items: game))
            }
            
            return combinedArrays
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
