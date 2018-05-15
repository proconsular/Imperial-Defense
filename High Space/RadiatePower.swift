//
//  RadiatePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/14/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RadiatePower: TimedUnitPower {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        soldier.behavior.base.append(TemporaryBehavior(RadiateBehavior(soldier.transform), 2))
    }
    
}


































