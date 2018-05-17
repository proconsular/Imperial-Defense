//
//  BarrierUpgrade.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BarrierUpgrade: Upgrade {
    let maximum: BarrierLayout
    
    init(_ maximum: BarrierLayout) {
        self.maximum = maximum
        super.init("Barrier", "Castle")
    }
    
    func apply(_ constructor: BarrierConstructor) {
        constructor.mods.append(BarrierLayout(maximum.health * range.percent, Int(Float(maximum.amount) * range.percent)))
    }
    
    override func computeCost() -> Int {
        return 4
    }
}
