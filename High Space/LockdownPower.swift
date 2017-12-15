//
//  LockdownBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LockdownPower: TimedUnitPower {
    unowned let soldier: Soldier
    let duration: Float
    
    init(_ soldier: Soldier, _ duration: Float, _ cost: Float, _ limit: Float) {
        self.soldier = soldier
        self.duration = duration
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
//        soldier.stop(duration) { [unowned soldier, unowned self] in
//            soldier.setImmunity(true, self.duration)
//        }
        soldier.behavior.push(TemporaryBehavior(Immunity(soldier), duration) { [unowned soldier] in
            soldier.shield_material?.overlay = false
        })
    }
}
