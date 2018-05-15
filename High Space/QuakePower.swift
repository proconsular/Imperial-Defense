//
//  QuakePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/13/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class QuakePower: TimedUnitPower {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        soldier.behavior.base.append(TemporaryBehavior(ShakeBehavior(0.25.m), 1) {
            Camera.current.transform.location = float2(0, -Camera.size.y)
        })
        
        Audio.play("shake", 0.25)
        Map.current.append(Halo(soldier.transform.location, 2.m))
    }
    
}
