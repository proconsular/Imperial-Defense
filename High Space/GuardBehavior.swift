//
//  GuardBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GuardBehavior: CooldownBehavior {
    unowned var entity: Entity
    let radius: Float
    
    var active: Bool = false
    
    init(_ entity: Entity, _ limit: Float) {
        self.entity = entity
        radius = 2.5.m
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        trigger()
    }
    
    override func trigger() {
        Map.current.apply(FixedRect(entity.transform.location, float2(radius))) { [unowned self] in
            if let soldier = $0 as? Soldier {
                self.apply(soldier)
            }
        }
        Explosion.create(entity.transform.location, radius, float4(1, 0, 0, 1))
        Audio.start("enemy-rush")
    }
    
    func apply(_ soldier: Soldier) {
        let animator = BaseMarchAnimator(soldier.body, 10, 0.0.m)
        animator.set(soldier.sprinter ? 1 : 0)
        soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.4) { [weak self] in
            //soldier.setImmunity(false)
            if let s = self {
                s.active = false
            }
        })
        soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.1) { [unowned soldier] in
            soldier.setImmunity(true, 0.4)
        })
    }
}
