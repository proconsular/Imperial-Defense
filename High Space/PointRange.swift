//
//  Status.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct PointRange {
    var amount: Float
    var limit: Float
    
    init(_ limit: Float) {
        self.limit = limit
        amount = limit
    }
    
    var percent: Float {
        return amount / limit
    }
    
    mutating func increase(_ value: Float) {
        amount = max(amount + value, 0)
    }
    
    mutating func recharge(_ value: Float) {
        amount = min(amount + value, limit)
    }
    
    mutating func overcharge(amount: Float) {
        self.amount = limit * amount
    }
}

class Status {
    var hitpoints: PointRange
    
    init(_ limit: Float) {
        hitpoints = PointRange(limit)
    }
}







