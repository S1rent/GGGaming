//
//  FavoriteViewModel.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[FavoriteModel]>
        let hasData: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        
        let data = input.loadTrigger.map { _ -> [FavoriteModel] in
            return FavoriteCoreDataFunctionality.shared.getFavorites()
        }
        
        let hasData = data.map { !($0.isEmpty) }
        
        return Output(
            data: data,
            hasData: hasData
        )
    }
}
