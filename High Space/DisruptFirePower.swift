//
//  DisruptFirePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DisruptFirePower: TimedUnitPower {
    unowned let soldier: Soldier
    let radius: Float
    
    init(_ soldier: Soldier, _ radius: Float, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.radius = radius
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        soldier.behavior.base.append(TemporaryBehavior(GravitateFireBehavior(soldier, radius), 2))
    }
}
