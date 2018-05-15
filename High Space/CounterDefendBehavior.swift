//
//  CounterAttackPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CounterDefendBehavior: Behavior, Damagable {
    var alive = true
    
    unowned let soldier: Soldier
    let reaction: DamageReaction
    let shield: Shield
    
    var active = true
    var damaged = false
    
    var battery: Battery
    
    var timer: Float = 0
    
    var gravitate: GravitateFireBehavior
    
    init(_ soldier: Soldier, _ battery: Battery) {
        self.soldier = soldier
        self.battery = battery
        reaction = soldier.reaction as! DamageReaction
        shield = soldier.health.shield!
        
        gravitate = GravitateFireBehavior(soldier, 5.m)
    }
    
    func update() {
        timer += Time.delta
        
        gravitate.update()
        
//        if active {
//            
//            if timer >= 1.75 {
//                timer = 0
//                active = false
//                battery.amount = 0
//            }
//        }else{
//            gravitate.polarity = -1
//            if timer >= 1.5 {
//                timer = 0
//                active = true
//            }
//        }
        
        
        
        gravitate.polarity = active ? 1 : -1
        
        if active {
            soldier.shield_material!.overlay = true
            soldier.shield_material!.overlay_color = float4(0.9) * (charge) + float4(0.9, 0.2, 0.2, 1) * 0.75 * (1 - charge)
            reaction.object = self
            shield.points.amount = shield.points.limit
        }else{
            soldier.shield_material!.overlay = false
            reaction.object = soldier
            shield.points.amount = 0
        }
        
        //battery.amount -= 50 * Time.delta
        
        active = battery.amount >= 10
        
        battery.amount = max(0, battery.amount)
        damaged = false
    }
    
    func damage(_ amount: Float) {
        battery.amount -= amount * 2
        damaged = true
    }
    
    var charge: Float {
        return battery.amount / 40
    }
    
}


























