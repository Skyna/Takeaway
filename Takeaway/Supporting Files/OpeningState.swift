//
//  OpeningState.swift
//  Takeaway
//
//  Created by Emre Akman on 14/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

public enum OpeningState{
    case open
    case closed
    case orderAhead
    case all
    
    var value : String{
        switch self {
        case .open:
            return "Open"
        case .closed:
            return "Closed"
        case .orderAhead:
            return "Order Ahead"
        case .all:
            return "All"
        }
    }
    
    var sortValue : String{
        switch self {
        case .open:
            return "open"
        case .closed:
            return "closed"
        case .orderAhead:
            return "order ahead"
        default: return ""
        }
    }
}
