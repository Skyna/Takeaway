//
//  RestaurantModel.swift
//  Takeaway
//
//  Created by Emre Akman on 14/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RestaurantModel {
    
    static let shared : RestaurantModel = RestaurantModel()
    
    var searchSubject               = BehaviorRelay<String>(value:"")
    var openChoiceForOpeningState   = PublishRelay<Bool>()
    var resetRestaurantList         = PublishRelay<Bool>()
    var currentSortOption           = BehaviorRelay<SortingOption>(value:.bestMatch)
    var currentOpeningState         = BehaviorRelay<SortingOption>(value:.openingState(.all))
    var currentSortIsReverse        = BehaviorRelay<Bool>(value: false)
    
    func sortByOpeningsState(_ restaurants : [Restaurant]) -> [Restaurant]{
        if self.currentOpeningState.value == .openingState(.open) {
            return restaurants.sorted{ $0.status == OpeningState.closed.sortValue && $1.status != OpeningState.closed.sortValue}
                              .sorted{ $0.status == OpeningState.orderAhead.sortValue && $1.status != OpeningState.orderAhead.sortValue}
                              .sorted{ $0.status == OpeningState.open.sortValue && $1.status != OpeningState.open.sortValue}
        }
        else if self.currentOpeningState.value == .openingState(.closed) {
            return restaurants.sorted{ $0.status == OpeningState.open.sortValue && $1.status != OpeningState.open.sortValue}
                              .sorted{ $0.status == OpeningState.orderAhead.sortValue && $1.status != OpeningState.orderAhead.sortValue}
                              .sorted{ $0.status == OpeningState.closed.sortValue && $1.status != OpeningState.closed.sortValue}
        }
        return restaurants
    }
    
    func sortByValue(_ restaurants : [Restaurant]) -> [Restaurant]{
        return restaurants.sorted(by: self.currentSortIsReverse.value ?
                                        self.currentSortOption.value.sortReverse :
                                        self.currentSortOption.value.sort)//Sort by value
    }
    
    func sort(_ restaurants : [Restaurant]) -> [Restaurant]{
        return sortByOpeningsState(sortByValue(restaurants))
    }
    
}
