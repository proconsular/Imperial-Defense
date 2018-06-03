//
//  SoldierTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Emperor: Soldier {
    static weak var instance: Emperor!
    
    var status: BossStatus!
    var laser: BossLaser!
    var shield: BossShield!
    
    var march: TimedBehavior!
    
    var dead = false
    
    required init(_ location: float2) {
        super.init(location, Health(2500, Shield(Float(50), Float(5), Float(60))), float4(1), "Emperor")
        status = BossStatus(health)
        handle.materials.removeLast()
        shield = BossShield(self)
        laser = BossLaser(location, transform, shield.particle_shielding)
        animator = BossMarchAnimator(body, 0.2, 26.m)
        march = TimedBehavior(MarchBehavior(self, animator), 2)
        
        BossSequencer.setSequence(self)
        Emperor.instance = self
    }
    
    override func damage(_ amount: Float) {
        let damage = shield.absorb(amount)
        super.damage(damage)
    }
    
    override func update() {
        if dead {
            behavior.update()
            return
        }
        super.update()
        laser.update()
        status.update()
        shield.update()
        updateCastle()
    }
    
    func updateCastle() {
        let broke = Game.instance.level.scenery.castle.brokeness
        if health.stamina.percent <= 0.5 && broke < 1 {
            Game.instance.level.scenery.castle.brokeness = 1
            play("barrier-destroyed")
        }
        if health.stamina.percent <= 0.25 && broke < 2 {
            Game.instance.level.scenery.castle.brokeness = 2
            play("barrier-destroyed")
        }
        if health.stamina.percent <= 0.1 && !Game.instance.level.scenery.castle.destroyed {
            Game.instance.level.scenery.castle.destroy()
        }
    }
    
    override func terminate() {
        if health.stamina.percent <= 0 && !dead {
            shield.particle_shielding.enabled = false
            behavior.push(DeathBehavior(self))
            dead = true
        }
    }
    
    override func render() {
        if !dead {
            laser.render()
            status.render()
        }
    }
}








