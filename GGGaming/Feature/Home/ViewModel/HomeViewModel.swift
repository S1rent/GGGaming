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
        let searchedText: Driver<String>
        let willAppearTrigger: Driver<Void>
    }
    
    struct Output {
        let developerData: Driver<[Developer]>
        let gameData: Driver<[Game]>
        let searchedGameData: Driver<[Game]>
        let loading: Driver<Bool>
        let developerNoData: Driver<Bool>
        let gameNoData: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        var searchKey = ""
        
        _ = input.willAppearTrigger.drive(onNext: {
            searchKey = ""
        })
        
        let developerData = input.loadTrigger.flatMapLatest { _ -> Driver<[Developer]> in
            
            return HomeNetworkProvider.shared
                .getHomeDeveloperList()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
    
        let searchedGameData = input.searchedText.flatMapLatest { string -> Driver<[Game]> in
            if string != "" && string != searchKey {
                searchKey = string
                return HomeNetworkProvider.shared
                    .getHomeSearchedGames(with: string)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
                    .asDriverOnErrorJustComplete()
            }
            
            return Driver.never()
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
                searchedGameData: searchedGameData,
                loading: activityTracker.asDriver(),
                developerNoData: developerNoData,
                gameNoData: gameNoData
            )
    }
}
