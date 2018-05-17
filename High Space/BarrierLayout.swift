//
//  BarrierLayout.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct BarrierLayout {
    var health: Float
    var amount: Int
    
    init(_ health: Float, _ amount: Int) {
        self.health = health
        self.amount = amount
    }
}
