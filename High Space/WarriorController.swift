//
//  WarriorController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class WarriorController: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    
    var spray: SprayFireBehavior
    var roam: RoamBehavior
    var reflect: ReflectBehavior
    
    var power: Float = 1
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        
        spray = SprayFireBehavior(soldier, 4)
        roam = RoamBehavior(soldier, 4)
        reflect = ReflectBehavior(soldier, 3)
    }
    
    func update() {
        spray.update()
        roam.update()
        reflect.update()
        
        let wave = GameData.info.wave + 1
        
        power += 0.25 * Time.delta
        
        if soldier.transform.location.y <= -Camera.size.y && ActorUtility.hasLineOfSight(soldier) { return }
        
        if spray.available && roll(0.25) && power >= 1 {
            spray.activate()
            power -= 1
        }
        
        if wave >= 35 && roam.available && roll(0.25) && power >= 1 {
            roam.activate()
            power -= 1
        }
        
        if wave >= 37 && reflect.available && roll(1 - soldier.health.shield!.percent) && power >= 1 {
            reflect.activate()
            power -= 1
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}
