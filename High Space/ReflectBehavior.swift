//
//  ReflectBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ReflectBehavior: CooldownBehavior {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ limit: Float) {
        self.soldier = soldier
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        soldier.behavior.push(TemporaryBehavior(EmptyBehavior(), 0.25) { [unowned soldier] in
            soldier.reaction = DamageReaction(soldier)
            soldier.shield_material!.overlay = false
        })
        soldier.reaction = ReflectReaction(soldier.body)
        soldier.shield_material!.overlay = true
        soldier.shield_material!.overlay_color = float4(0.3, 0.6, 1, 1) * 0.75
        if let shield = soldier.health.shield {
            shield.points.amount = shield.points.limit
        }
    }
    
}
