//
//  GravitateUnitsPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/13/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GravitateUnitsPower: TimedUnitPower {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        soldier.behavior.base.append(TemporaryBehavior(PullUnitsBehavior(soldier.transform, 5.m), 0.1))
        Audio.play("pull-close", 0.75)
    }
    
}
