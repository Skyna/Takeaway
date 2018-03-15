//
//  SortingModel.swift
//  Takeaway
//
//  Created by Emre Akman on 14/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SortingModel {
    
    static let shared : SortingModel = SortingModel()
    
    var openChoiceForOpeningState   = PublishRelay<Bool>()
    var currentSortOption           = BehaviorRelay<SortingOption>(value:.bestMatch)
    var currentOpeningState         = BehaviorRelay<SortingOption>(value:.openingState(.all))
    var currentSortIsReverse        = BehaviorRelay<Bool>(value: false)
    
}
