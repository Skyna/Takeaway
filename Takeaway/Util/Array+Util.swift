//
//  Array+Util.swift
//  Takeaway
//
//  Created by Emre Akman on 16/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == Int  {
    func isSorted() -> Bool {
        for(index, item) in self.enumerated() {
            guard index + 1 >= self.count else { break }
            if self[index + 1] > item {
                return false
            }
        }
        return true
    }
}

extension Array where Iterator.Element == Double  {
    func isSorted() -> Bool {
        for(index, item) in self.enumerated() {
            guard index + 1 >= self.count else { break }
            if self[index + 1] > item {
                return false
            }
        }
        return true
    }
}
