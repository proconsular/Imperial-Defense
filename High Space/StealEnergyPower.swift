//
//  StealEnergyBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StealEnergyPower: TimedUnitPower {
    unowned let soldier: Soldier
    unowned let battery: Battery
    let radius: Float
    let time: Float
    
    init(_ soldier: Soldier, _ battery: Battery, _ radius: Float, _ time: Float, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.battery = battery
        self.radius = radius
        self.time = time
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        soldier.behavior.base.append(TemporaryBehavior(AbsorbBehavior(soldier, battery, radius), time))
        Audio.play("absorb-shield", 0.5)
    }
}
