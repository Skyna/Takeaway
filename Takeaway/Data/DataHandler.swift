//
//  DataHandler.swift
//  Takeaway
//
//  Created by Emre Akman on 14/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation
import RxCocoa

class DataHandler {
    static func getRestaurants() -> BehaviorRelay<[Restaurant]>{
        let restaurantsRelay = BehaviorRelay<[Restaurant]>(value: [])
        do {
            let dictionary : [String:[Restaurant]] = try JSONParser.parse("sample")
            if let restaurants = dictionary["restaurants"] {
                restaurantsRelay.accept(restaurants)
                return restaurantsRelay
            }
        } catch {
            print("error", error)
        }
        return restaurantsRelay
    }
}
