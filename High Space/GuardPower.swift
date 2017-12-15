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
        Audio.start("enemy-rush")
    }
    
    func apply(_ soldier: Soldier) {
//        let animator = BaseMarchAnimator(soldier.body, 10, 0.0.m)
//        animator.set(soldier.sprinter ? 1 : 0)
//        soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.4) { [weak self] in
//            //soldier.setImmunity(false)
//            if let s = self {
//                s.active = false
//            }
//        })
//        soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.1) { [unowned soldier] in
//            soldier.setImmunity(true, 0.4)
//        })
        soldier.behavior.push(TemporaryBehavior(Immunity(soldier), 0.5) { [unowned soldier] in
            soldier.shield_material?.overlay = false
        })
    }
}
