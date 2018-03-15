//
//  Restaurant.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

struct Restaurant : Codable {
    var name            : String
    var status          : String
    var sortingValues   : SortingValues
    
    func sortValue(_ option : SortingOption) -> String{
        switch option {
        case .bestMatch:
            return String(describing:self.sortingValues.bestMatch)
        case .newest:
            return String(describing:self.sortingValues.newest)
        case .ratingAverage:
            return String(describing:self.sortingValues.ratingAverage)
        case .distance:
            return String(describing:self.sortingValues.distance)
        case .popularity:
            return String(describing:self.sortingValues.popularity)
        case .averageProductPrice:
            return String(describing:self.sortingValues.averageProductPrice)
        case .deliveryCosts:
            return String(describing:self.sortingValues.deliveryCosts)
        case .minCost:
            return String(describing:self.sortingValues.minCost)
        default: return ""
        }
    }
}

struct SortingValues : Codable {
    let bestMatch           : Double
    let newest              : Double
    let ratingAverage       : Double
    let distance            : Int
    let popularity          : Double
    let averageProductPrice : Int
    let deliveryCosts       : Int
    let minCost             : Int
}
