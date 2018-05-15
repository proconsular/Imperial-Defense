//
//  RankedPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct RankedPower {
    var rank: Int
    var power: UnitPower
    
    init(_ rank: Int, _ power: UnitPower) {
        self.rank = rank
        self.power = power
    }
}
