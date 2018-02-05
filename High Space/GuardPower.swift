//
//  GuardBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GuardPower: TimedUnitPower {
    unowned var entity: Entity
    let radius: Float
    
    var active: Bool = false
    
    init(_ entity: Entity, _ cost: Float, _ limit: Float) {
        self.entity = entity
        radius = 2.5.m
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        Map.current.apply(FixedRect(entity.transform.location, float2(radius))) { [unowned self] in
            if let soldier = $0 as? Soldier {
                self.apply(soldier)
            }
        }
        Explosion.create(entity.transform.location, radius, float4(1, 0, 0, 1))
        Audio.play("enemy-rush", 0.2)
    }
    
    func apply(_ soldier: Soldier) {
        soldier.behavior.push(TemporaryBehavior(Immunity(soldier), 0.5) { [unowned soldier] in
            soldier.shield_material?.overlay = false
        })
    }
}
