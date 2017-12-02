//
//  CaptainController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CaptainController: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    
    var charge: RushBehavior
    var protect: GuardBehavior
    var fire: AllfireBehavior
    
    var power: Float = 1
    var save: Int = 1
    
    var queued: CooldownBehavior?
    var timer: Float = 0
    var flicker: Float = 0
    var shield_on: Bool = true
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        
        charge = RushBehavior(soldier.transform, 3.m, 4)
        protect = GuardBehavior(soldier, 4)
        fire = AllfireBehavior(soldier.transform, 3.m, 4)
    }
    
    func update() {
        charge.update()
        protect.update()
        fire.update()
        
        let wave = GameData.info.wave + 1
        
        if soldier.transform.location.y <= -Camera.size.y { return }
        
        power += 0.2 * Time.delta
        
        if !ActorUtility.hasLineOfSight(soldier) { return }
        
        if let player = Player.player {
            let dx = soldier.transform.location.x - player.transform.location.x
            
            let char = roll(clamp(abs(dx / 2.m), min: 0, max: 1))
            if char && roll(0.1) && charge.available && power >= 1 {
                queue(charge, 0.25)
                power -= 1
            }
            
            let pro = roll(1 - clamp(abs(dx / 0.5.m), min: 0, max: 1))
            if wave >= 23 && roll(0.1) && pro && protect.available && power >= 1 {
                queue(protect, 0.25)
                power -= 1
            }
            
            let fir = roll(1 - clamp(abs(dx / 1.m), min: 0, max: 1))
            if wave >= 27 && fir && fire.available && power >= 1 {
                queue(fire, 0.25)
                power -= 1
            }
            
            if wave >= 33 && soldier.health.percent <= 0.25 && power >= 1 && save > 0 {
                soldier.stop(2) { [unowned soldier] in
                    soldier.setImmunity(true, 0.5)
                }
                
                power = 0
                save -= 1
            }
        }
        
        timer -= Time.delta
        
        if timer > 0 {
            flicker += Time.delta
            if flicker >= 0.05 {
                flicker = 0
                let sh = soldier.shield_material!.color
                shield_on = !shield_on
                soldier.shield_material!.overlay_color = shield_on ? float4(1, 0, 0, 1) * Float(0.5) : sh
            }
        }
        
        if timer <= 0 {
            if let saved = queued {
                saved.activate()
                soldier.shield_material!.overlay = false
                queued = nil
            }
        }
    }
    
    func queue(_ behavior: CooldownBehavior, _ time: Float) {
        if queued == nil {
            queued = behavior
            timer = time
            soldier.shield_material!.overlay = true
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}





























