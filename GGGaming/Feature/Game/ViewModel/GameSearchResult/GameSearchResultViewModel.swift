//
//  GameSearchResultViewModel.swift
//  GGGaming
//
//  Created by IT Division on 14/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class GameSearchResultViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[Game]>
        let noData: Driver<Bool>
    }
    
    let gameData: [Game]
    
    init(data: [Game]) {
        self.gameData = data
    }
    
    public func transform(input: Input) -> Output {
        let gameData = input.loadTrigger.flatMapLatest { _ -> Driver<[Game]> in
            return Driver.just(self.gameData)
        }
        
        let noData = gameData.map { !($0.isEmpty) }
        
        return Output(
            data: gameData,
            noData: noData
        )
    }
}
