//
//  DodgeBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class DodgeBehavior: Behavior {
    
    var alive: Bool = true
    
    unowned var entity: Entity
    var cooldown: Float
    var rate: Float
    
    init(_ entity: Entity, _ rate: Float) {
        self.entity = entity
        self.rate = rate
        cooldown = 0
    }
    
    func update() {
        cooldown -= Time.delta
        if cooldown <= 0 {
            if detectFire() {
                let direction = computeJumpDirection()
                if direction != 0 {
                    Map.current.append(GhostEffect(entity, 2))
                    let e = GhostEffect(entity, 2)
                    e.transform.location.x += direction * (0.75.m / 2)
                    Map.current.append(e)
                    entity.transform.location.x += direction * 0.75.m
                    cooldown = rate
                    play("enemy-dodge")
                    
                }
            }
        }
    }
    
    func detectFire() -> Bool {
        let units = Map.current.getActors(rect: FixedRect(entity.transform.location, float2(0.5.m, 2.m)))
        for u in units {
            if let bullet = u as? Bullet, bullet.casing.tag == "enemy" {
                return true
            }
        }
        return false
    }
    
    func computeJumpDirection() -> Float {
        var direction: Float = 0
        let range = 1.55.m
        let units = Map.current.getActors(rect: FixedRect(entity.transform.location, float2(range, 0.5.m)))
        var right = true, left = true
        for u in units {
            if u === entity || u.body.mask == 0 { continue }
            let dx = u.transform.location.x - entity.transform.location.x
            if dx < 0 {
                left = false
            }
            if dx > 0 {
                right = false
            }
            if dx == 0 {
                left = false
                right = false
            }
        }
        if right {
            direction = 1
        }
        if left {
            direction = -1
        }
        if left && right {
            direction = arc4random() % 2 == 0 ? 1 : -1
        }
        return direction
    }
    
}
