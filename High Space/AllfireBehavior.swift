//
//  AllfireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class AllfireBehavior: CooldownBehavior {
    unowned let transform: Transform
    let radius: Float
    
    init(_ transform: Transform, _ radius: Float, _ limit: Float) {
        self.transform = transform
        self.radius = radius
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        BehaviorQueue.instance.submit(BehaviorRequest("allfire", self))
    }
    
    override func trigger() {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier, ActorUtility.hasLineOfSight(soldier) {
                let animator = BaseMarchAnimator(soldier.body, 10, 0.0.m)
                animator.set(soldier.sprinter ? 1 : 0)
                for _ in 0 ..< 5 {
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
