//
//  Restaurant.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

struct Restaurant : Decodable {
    var name            : String
    var status          : String
    var sortingValues   : SortingValues
}

struct SortingValues : Decodable {
    let bestMatch           : Double
    let newest              : Double
    let ratingAverage       : Double
    let distance            : Int
    let popularity          : Double
    let averageProductPrice : Int
    let deliveryCosts       : Int
    let minCost             : Int
}
