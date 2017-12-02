//
//  TitanController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TitanController: Behavior, Damagable {
    var alive = true
    
    unowned let soldier: Soldier
    let reaction: DamageReaction
    let shield: Shield
    
    var invulnerable: Bool = true
    var damaged = false
    
    var power: Float = 1
    var absorbed: Float = 0
    var timer: Float = 0
    
    let absorber: AbsorbBehavior
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        reaction = soldier.reaction as! DamageReaction
        shield = soldier.health.shield!
        
        absorber = AbsorbBehavior(soldier, 4.m, 2)
    }
    
    func update() {
        absorber.update()
        
        power += Time.delta
        
        if invulnerable {
            soldier.immune = true
            soldier.shield_material!.overlay = true
            soldier.shield_material!.overlay_color = float4(0.9) * (1 - charge) + float4(0.9, 0.2, 0.2, 1) * 0.75 * charge
            reaction.object = self
            shield.points.amount = shield.points.limit
        }else{
            soldier.immune = false
            soldier.shield_material!.overlay = false
            reaction.object = soldier
            shield.points.amount = 0
        }
        
        if soldier.transform.location.y <= -Camera.size.y - 2.m { return }
        
        timer += Time.delta
        
        if invulnerable {
            if timer >= 1.75 {
                timer = 0
                invulnerable = false
                absorbed = 0
            }
        }else{
            if timer >= 1.5 {
                timer = 0
                invulnerable = true
            }
        }
        
        if invulnerable {
            if !damaged {
                absorbed -= 60 * Time.delta
            }
            if charge > 1 && roll(0.1) {
                attack(charge)
                absorbed = 0
            }
        }
        
        if charge <= 0.9 {
            if power >= 8 && absorber.power <= 50 && roll(0.1) {
                power -= 8
                absorber.activate()
            }
            
            if absorber.power > 50 && power >= 4 && roll(0.1) && ActorUtility.hasLineOfSight(soldier) {
                attack(clamp(absorber.power / 50, min: 0, max: 1.25))
                absorber.power = 0
            }
        }
        
        absorbed = max(0, absorbed)
        damaged = false
    }
    
    func attack(_ charge: Float) {
        let bullet = Bullet(soldier.transform.location, float2(0, 1), Impact(charge * 200, 12.m), Casing(float2(1.4.m, 0.4.m), float4(1), "player", 2))
        bullet.terminator = MissileExplosion(bullet, charge * 3.m)
        Map.current.append(bullet)
    }
    
    var charge: Float {
        return absorbed / 40
    }
    
    func damage(_ amount: Float) {
        absorbed += amount
        damaged = true
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}






















