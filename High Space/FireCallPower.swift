//
//  AllfireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FireCallPower: TimedUnitPower {
    unowned let transform: Transform
    let radius: Float
    let amount: Int
    
    init(_ transform: Transform, _ radius: Float, _ amount: Int, _ cost: Float, _ limit: Float) {
        self.transform = transform
        self.radius = radius
        self.amount = amount
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier, ActorUtility.hasLineOfSight(soldier) {
                let animator = BaseMarchAnimator(soldier.body, 10, 0.0.m)
                animator.set(soldier.sprinter ? 1 : 0)
                for _ in 0 ..< amount {
                    soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.125) { [unowned soldier] in
                        soldier.weapon?.fire()
                        Audio.start("shoot3")
                    })
                }
            }
        }
        Explosion.create(transform.location, radius, float4(1, 0, 0, 1))
        Audio.start("enemy-allfire")
    }
    
}
