//
//  EnergyBlastPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyBlastPower: TimedUnitPower {
    unowned let soldier: Soldier
    unowned let battery: Battery
    unowned let pool: BlastPool
    
    init(_ soldier: Soldier, _ battery: Battery, _ pool: BlastPool, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.battery = battery
        self.pool = pool
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        let blast = EnergyBlast(soldier.transform.location, clamp(battery.amount - 50, min: 25, max: 75))
        blast.velocity = float2(0, random(0.25.m, 2.m))
        pool.blasts.append(blast)
        battery.amount = 75
        
        Audio.play("fire-energy", 0.5)
    }
}
