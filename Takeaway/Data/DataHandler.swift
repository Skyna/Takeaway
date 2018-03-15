//
//  DataHandler.swift
//  Takeaway
//
//  Created by Emre Akman on 14/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

class DataHandler {
    
    static func getRestaurants() -> [Restaurant]{
        do {
            let dictionary : [String:[Restaurant]] = try JSONParser.parse("sample")
            if let restaurants = dictionary["restaurants"] {
                return restaurants
            }
        } catch {
            print("error", error)
        }
        return []
    }
    
    static func getNonFavoriteRestaurants() -> [Restaurant]{
        return DataHandler.getRestaurants().filter{!Storage.fileExists($0.name)}
    }
    
    static func getFavoriteRestaurants() -> [Restaurant]{
        return DataHandler.getRestaurants().filter{Storage.fileExists($0.name)}
    }
}
