//
//  GameDetailViewModel.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class GameDetailViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<GameDetailResponseWrapper>
        let loading: Driver<Bool>
        let action: Driver<Bool>
    }
    
    let gameID: Int
    
    init(gameID: Int) {
        self.gameID = gameID
    }
    
    public func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<GameDetailResponseWrapper> in
            
            return GameNetworkProvider.shared
                .getGameDetail(with: self.gameID)
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let isInsideUserWishlist = input.loadTrigger.map { _ -> Bool in
            return FavoriteCoreDataFunctionality.shared.getGame(id: self.gameID)
        }
        
        return Output(
            data: data,
            loading: activityTracker.asDriver(),
            action: isInsideUserWishlist
        )
    }
}
