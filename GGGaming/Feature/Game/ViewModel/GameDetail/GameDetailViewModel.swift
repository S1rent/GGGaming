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
    
    let gameData: Game
    
    init(gameData: Game) {
        self.gameData = gameData
    }
    
    public func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<GameDetailResponseWrapper> in
            
            return GameNetworkProvider.shared
                .getGameDetail(with: self.gameData.gameID ?? 0)
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let isInsideUserWishlist = input.loadTrigger.map { _ -> Bool in
            return Wishlist.shared.isGameInsideWishList(gameData: self.gameData)
        }
        
        return Output(
            data: data,
            loading: activityTracker.asDriver(),
            action: isInsideUserWishlist
        )
    }
}
