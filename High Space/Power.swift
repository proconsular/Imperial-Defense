//
//  Power.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct Power {
    var amount: Float
    var limit: Float
    
    var recharge: Float
    var drain: Float
    
    init(_ limit: Float, _ recharge: Float, _ drain: Float) {
        self.limit = limit
        self.amount = limit
        self.recharge = recharge
        self.drain = drain
    }
    
    mutating func use() {
        amount = max(amount - drain, 0)
    }
    
    mutating func charge(_ mod: Float = 1) {
        if amount < limit {
            amount += recharge * mod * Time.delta
            amount = clamp(amount, min: 0, max: limit)
        }
    }
    
    var percent: Float {
        return amount / limit
    }
    
    var usable: Bool {
        return amount >= drain
    }
}
