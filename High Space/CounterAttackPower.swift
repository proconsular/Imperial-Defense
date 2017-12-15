//
//  CounterAttackPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CounterAttackPower: TimedUnitPower {
    
    unowned let soldier: Soldier
    unowned let battery: Battery
    
    init(_ soldier: Soldier, _ battery: Battery, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.battery = battery
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        let bullet = Bullet(soldier.transform.location, float2(0, 1), Impact(battery.percent * 200, 18.m), Casing(float2(1.5.m, 0.5.m), float4(1), "player"))
        bullet.terminator = MissileExplosion(bullet, battery.percent * 1.5.m + 1.5.m)
        Map.current.append(bullet)
        
        battery.amount = 0
    }
    
}
