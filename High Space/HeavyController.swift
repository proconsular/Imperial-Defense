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
    var lockdown: LockdownBehavior
    
    var power: Float = 1
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        
        rapidfire = RapidFireBehavior(soldier, 8)
        missilefire = MissileFireBehavior(soldier, 8)
        lockdown = LockdownBehavior(soldier, 0.25, 3)
    }
    
    func update() {
        rapidfire.update()
        missilefire.update()
        lockdown.update()
        
        let wave = GameData.info.wave + 1
        
        power += 0.25 * Time.delta
        
        if soldier.transform.location.y <= -Camera.size.y - 2.m { return }
        
        if rapidfire.available && roll(0.01) && power >= 1 {
            rapidfire.activate()
            power -= 1
        }
        
        if wave >= 25 && missilefire.available && roll(0.01) && power >= 1 {
            missilefire.activate()
            power -= 1
        }
        
        if wave >= 29 && lockdown.available && soldier.health.shield!.percent <= 0.25 && power >= 1 {
            lockdown.activate()
            power -= 1
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}
