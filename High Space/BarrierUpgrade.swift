//
//  BarrierUpgrade.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
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

class BarrierConstructor {
    
    let layout: BarrierLayout
    
    var mods: [BarrierLayout]
    
    init(_ layout: BarrierLayout) {
        self.layout = layout
        mods = []
    }
    
    func construct(_ height: Float) -> [Wall] {
        let final = computeFinalLayout()
        var barriers: [Wall] = []
        for i in 0 ..< final.amount {
            let dis = 4.m
            let loc = Map.current.size.x / 2 + Float(i - final.amount / 2) * dis + dis / 2
            let wall = Wall(float2(loc, height), final.health)
            barriers.append(wall)
            Map.current.append(wall)
        }
        return barriers
    }
    
    func computeFinalLayout() -> BarrierLayout {
        var final = layout
        for m in mods {
            final.amount += m.amount
            final.health += m.health
        }
        return final
    }
    
}
