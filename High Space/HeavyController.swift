//
//  HeavyController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/23/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HeavyController: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    
    var rapidfire: RapidFireBehavior
    var missilefire: MissileFireBehavior
    
    var power: Float = 0
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        
        rapidfire = RapidFireBehavior(soldier, 6)
        missilefire = MissileFireBehavior(soldier, 6)
    }
    
    func update() {
        rapidfire.update()
        missilefire.update()
        
        power += 0.25 * Time.delta
        
        if soldier.transform.location.y <= -Camera.size.y { return }
        
        if rapidfire.available && roll(0.25) && power >= 1 {
            rapidfire.activate()
            power -= 1
        }
        
        if missilefire.available && roll(0.75) && power >= 1 {
            missilefire.activate()
            power -= 1
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}
