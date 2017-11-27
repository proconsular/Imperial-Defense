//
//  PlayerWeapon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerWeapon: Weapon {
    
    var power: Power
    
    var rate_modifier: Float = 1
    
    var fired = true
    
    var delegate: WeaponDelegate?
    
    init(_ transform: Transform, _ direction: float2, _ power: Power, _ firer: Firer) {
        self.power = power
        super.init(transform, direction, firer)
    }
    
    var percent: Float {
        return power.percent
    }
    
    var color: float4 {
        return float4(1, 0, 0, 1)
    }
    
    override func update() {
        super.update()
        
        if isNormalPower {
            rate_modifier = 1
        }
        
        if isLowPower {
            rate_modifier = 2
        }
        
        if isHighPower {
            rate_modifier = 0.75
        }
        
        firer.impact.damage = 15
        if upgrader.firepower.range.percent == 1 {
            if random(0, 1) <= 0.1 {
                firer.impact.damage = 45
            }
        }
        
        power.charge(1 / rate_modifier)
        
        delegate?.update()
        
        fired = false
    }
    
    var isNormalPower: Bool {
        return power.amount > power.drain
    }
    
    var isHighPower: Bool {
        return power.amount >= power.limit - power.drain
    }
    
    var isLowPower: Bool {
        return power.amount <= power.drain
    }
    
    override var canFire: Bool {
        return firer.counter >= firer.rate * rate_modifier && power.usable
    }
    
    override func fire() {
        super.fire()
        power.use()
        fired = true
    }
    
}
