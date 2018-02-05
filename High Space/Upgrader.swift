//
//  Upgrader.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Upgrader {
    
    let firepower: FirePowerUpgrade
    let shieldpower: ShieldUpgrade
    let barrier: BarrierUpgrade
    
    var upgrades: [Upgrade]
    
    init() {
        firepower = FirePowerUpgrade(Power(175, 250, 0))
        shieldpower = ShieldUpgrade(ShieldPower(140, 100))
        barrier = BarrierUpgrade(BarrierLayout(2000, 2))
        
        upgrades = [firepower, shieldpower, barrier]
    }
    
    var shieldColor: float4 {
        let blue = float4(71 / 255, 71 / 255, 255 / 255, 1)//float4(48 / 255, 181 / 255, 206 / 255, 1)
        //let green = float4(63 / 255, 206 / 255, 48 / 255, 1)
        return blue //* (1 - shieldpower.range.percent) + green * shieldpower.range.percent
    }
    
}
