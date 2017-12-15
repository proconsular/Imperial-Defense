//
//  RapidFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RapidFirePower: TimedUnitPower {
    unowned var soldier: Soldier
    let duration: Float
    
    init(_ soldier: Soldier, _ duration: Float, _ cost: Float, _ limit: Float) {
        self.soldier = soldier
        self.duration = duration
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        soldier.behavior.push(TemporaryBehavior(FireBehavior(soldier, 0.1), duration))
    }
}
