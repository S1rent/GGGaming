//
//  HomeViewModel.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[Developer]>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[Developer]> in
            
            return HomeNetworkProvider.shared
                .getHomeDeveloperList()
                .trackError(errorTracker)
                .trackActivity(activityTracker)
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
