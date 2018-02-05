//
//  ReflectBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ReflectPower: TimedUnitPower {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ limit: Float) {
        self.soldier = soldier
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        soldier.behavior.push(TemporaryBehavior(EmptyBehavior(), 0.5) { [unowned soldier] in
            soldier.reaction = DamageReaction(soldier)
            soldier.shield_material!.overlay = false
        })
        soldier.reaction = ReflectReaction(soldier.body)
        soldier.shield_material!.overlay = true
        soldier.shield_material!.overlay_color = float4(39 / 255, 215 / 255, 1, 1) * 0.9
        if let shield = soldier.health.shield {
            shield.points.amount = shield.points.limit
        }
        Audio.play("enemy-shield-reflect", 0.5)
    }
}
