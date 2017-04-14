//
//  Upgrades.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/14/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Upgrade {
    var name: String
    var range: PointRange
    
    init(_ name: String) {
        self.name = name
        range = PointRange(5)
        range.amount = 0
    }
    
    func upgrade() {
        range.increase(1)
    }
    
    func computeCost() -> Int {
        return Int(20)
    }
}

class FirePowerUpgrade: Upgrade {
    
    let maximum: Impact
    
    init(_ maximum: Impact) {
        self.maximum = maximum
        super.init("Gun")
    }
    
    func apply(_ firer: Firer) {
        firer.mods.append(Impact(maximum.damage * range.percent, maximum.speed * range.percent))
    }
    
}

class ShieldUpgrade: Upgrade {
    
    let maximum: ShieldPower
    
    init(_ maximum: ShieldPower) {
        self.maximum = maximum
        super.init("Shield")
    }
    
    func apply(_ shield: Shield) {
        shield.mods.append(ShieldPower(maximum.amount * range.percent, maximum.recharge * range.percent))
    }
    
}

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
        super.init("Barrier")
    }
    
    func apply(_ constructor: BarrierConstructor) {
        constructor.mods.append(BarrierLayout(maximum.health * range.percent, Int(Float(maximum.amount) * range.percent)))
    }
    
}

class BarrierConstructor {
    
    let layout: BarrierLayout
    
    var mods: [BarrierLayout]
    
    init(_ layout: BarrierLayout) {
        self.layout = layout
        mods = []
    }
    
    func construct(_ height: Float, _ size: int2) -> [Wall] {
        let final = computeFinalLayout()
        var barriers: [Wall] = []
        for i in 0 ..< final.amount {
            let div = Map.current.size.x / Float(final.amount)
            let dis = 3.m
            let loc = div + Float(i * final.amount) * dis - dis
            let wall = Wall(float2(loc, height))
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












