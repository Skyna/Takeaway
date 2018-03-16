//
//  SortingOptions.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

public enum SortingOption{
    case openingState(OpeningState)
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minCost
    case none
    
    var name : String{
        switch self {
        case .openingState(.all):
            return OpeningState.all.value
        case .openingState(.closed):
            return OpeningState.closed.value
        case .openingState(.orderAhead):
            return OpeningState.orderAhead.value
        case .openingState(.open):
            return OpeningState.open.value
        case .bestMatch:
            return "Best Match"
        case .newest:
            return "Newest"
        case .ratingAverage:
            return "Rating Average"
        case .distance:
            return "Distance"
        case .popularity:
            return "Popularity"
        case .averageProductPrice:
            return "Average Product Price"
        case .deliveryCosts:
            return "Delivery Cost"
        case .minCost:
            return "Min Cost"
        case .none:
            return "None"
        }
    }
    
    var sortValue : String{
        switch self {
        case .openingState(.all):
            return OpeningState.all.sortValue
        case .openingState(.closed):
            return OpeningState.closed.sortValue
        case .openingState(.orderAhead):
            return OpeningState.orderAhead.sortValue
        case .openingState(.open):
            return OpeningState.open.sortValue
        default: return ""
        }
    }
    
    func sort(a : Restaurant, b : Restaurant) -> Bool{
        switch self {
        case .bestMatch:
            return a.sortingValues.bestMatch < b.sortingValues.bestMatch
        case .newest:
            return a.sortingValues.newest < b.sortingValues.newest
        case .ratingAverage:
            return a.sortingValues.ratingAverage < b.sortingValues.ratingAverage
        case .distance:
            return a.sortingValues.distance < b.sortingValues.distance
        case .popularity:
            return a.sortingValues.popularity < b.sortingValues.popularity
        case .averageProductPrice:
            return a.sortingValues.averageProductPrice < b.sortingValues.averageProductPrice
        case .deliveryCosts:
            return a.sortingValues.deliveryCosts < b.sortingValues.deliveryCosts
        case .minCost:
            return a.sortingValues.minCost < b.sortingValues.minCost
        default: return false
        }
    }
    
    func sortReverse(a : Restaurant, b : Restaurant) -> Bool{
        switch self {
        case .bestMatch:
            return a.sortingValues.bestMatch > b.sortingValues.bestMatch
        case .newest:
            return a.sortingValues.newest > b.sortingValues.newest
        case .ratingAverage:
            return a.sortingValues.ratingAverage > b.sortingValues.ratingAverage
        case .distance:
            return a.sortingValues.distance > b.sortingValues.distance
        case .popularity:
            return a.sortingValues.popularity > b.sortingValues.popularity
        case .averageProductPrice:
            return a.sortingValues.averageProductPrice > b.sortingValues.averageProductPrice
        case .deliveryCosts:
            return a.sortingValues.deliveryCosts > b.sortingValues.deliveryCosts
        case .minCost:
            return a.sortingValues.minCost > b.sortingValues.minCost
        default: return false
        }
    }
    
    var isOpeningState : Bool{
        return self == SortingOption.openingState(.all) ||
               self == SortingOption.openingState(.open) ||
               self == SortingOption.openingState(.orderAhead) ||
               self == SortingOption.openingState(.closed)
    }
    
}

extension SortingOption : Equatable{
    public static func ==(lhs: SortingOption, rhs: SortingOption) -> Bool {
        return lhs.name == rhs.name
    }
}
