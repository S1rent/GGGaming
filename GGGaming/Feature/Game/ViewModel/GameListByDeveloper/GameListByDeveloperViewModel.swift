//
//  GameListByDeveloperViewModel.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class GameListByDeveloperViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<[Game]>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
    }
    
    let developerData: Developer
    
    init(data: Developer) {
        self.developerData = data
    }
    
    public func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[Game]> in
            
            return GameNetworkProvider.shared.getGameListByDeveloperID(with: self.developerData.developerID ?? -1)
                .trackActivity(activityTracker)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let noData = data.map { !($0.isEmpty) }
        
        return Output(
            data: data,
            loading: activityTracker.asDriver(),
            noData: noData
        )
    }
}
