//
//  SoldierBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SoldierBehavior {
    
    var main: SerialBehavior
    var base: ComplexBehavior
    
    init() {
        main = SerialBehavior()
        base = ComplexBehavior()
        main.stack.push(base)
    }
    
    func update() {
        main.update()
    }
    
    func push(_ behavior: Behavior) {
        main.stack.push(behavior)
    }
    
}

class RushBehavior: Behavior {
    
    var alive = true
    var rushed: Bool
    var transform: Transform
    var radius: Float
    
    init(_ transform: Transform, _ radius: Float) {
        rushed = false
        self.radius = radius
        self.transform = transform
    }
    
    func update() {
        if transform.location.y >= -Camera.size.y {
            if !rushed {
                if random(0, 1) <= 0.2 {
                    rush(radius)
                    play("charge")
                    rushed = true
                }
            }
        }
    }
    
    func rush(_ radius: Float) {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                let animator = BaseMarchAnimator(soldier.body, 0.025, 0.175.m)
                soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 6))
            }
        }
        let ex = Explosion(transform.location, radius)
        ex.color = float4(1, 0, 0, 1)
        Map.current.append(ex)
    }
    
}
