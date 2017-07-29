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

protocol TriggeredBehavior: Behavior {
    func trigger()
}

class RushBehavior: TriggeredBehavior {
    
    var alive = true
    var rushed: Bool
    var transform: Transform
    var radius: Float
    var counter: Float = 0
    var rate: Float
    
    init(_ transform: Transform, _ radius: Float) {
        rushed = false
        self.radius = radius
        self.transform = transform
        rate = random(2, 4)
    }
    
    func update() {
        if transform.location.y >= -Camera.size.y {
            counter += Time.delta
            if counter >= rate {
                counter = 0
                request()
            }
        }
    }
   
    func request() {
        BehaviorQueue.instance.submit(BehaviorRequest("rush", self))
    }
    
    func trigger() {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                soldier.sprint()
            }
        }
        let ex = Explosion(transform.location, radius)
        ex.color = float4(1, 0, 0, 1)
        Map.current.append(ex)
        play()
        rate = random(4, 6)
    }
    
    func play() {
        let r = Audio("enemy-rush")
        r.volume = 1
        r.start()
    }
    
}

class DodgeBehavior: Behavior {
    
    var alive: Bool = true
    
    var entity: Entity
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
            if u === entity { continue }
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

class AllfireBehavior: Behavior {
    
    var alive: Bool = true
    var entity: Entity
    var cooldown: Float
    
    init(_ entity: Entity) {
        self.entity = entity
        cooldown = random(2, 6)
    }
    
    func update() {
        if entity.transform.location.y >= -Camera.size.y {
            cooldown -= Time.delta
            if cooldown <= 0 {
                fire(3.m)
                let a = Audio("enemy-allfire")
                a.volume = 1
                a.start()
                cooldown = random(2, 4)
            }
        }
    }
    
    func fire(_ radius: Float) {
        let actors = Map.current.getActors(rect: FixedRect(entity.transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                let animator = BaseMarchAnimator(soldier.body, 10, 0.0.m)
                animator.set(soldier.sprinter ? 1 : 0)
                soldier.behavior.push(TemporaryBehavior(MarchBehavior(soldier, animator), 0.5) {
                    soldier.weapon?.fire()
                    let s = Audio("shoot3")
                    s.volume = sound_volume
                    s.start()
                })
            }
        }
        let ex = Explosion(entity.transform.location, radius)
        ex.color = float4(1, 1, 1, 1)
        Map.current.append(ex)
    }
    
}

class FireBehavior: Behavior {
    
    var alive: Bool = true
    var soldier: Soldier
    var cooldown: Float
    var rate: Float
    
    init(_ soldier: Soldier, _ rate: Float) {
        self.soldier = soldier
        cooldown = rate
        self.rate = rate
    }
    
    func update() {
        cooldown -= Time.delta
        if cooldown <= 0 {
            if let gun = soldier.weapon {
                gun.fire()
                let s = Audio("shoot3")
                s.volume = sound_volume
                s.start()
                cooldown = rate
            }
        }
    }
    
    
}

class RapidFireBehavior: Behavior {
    
    var alive: Bool = true
    var soldier: Soldier
    var cooldown: Float
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
        cooldown = random(3, 5)
    }
    
    func update() {
        cooldown -= Time.delta
        if cooldown <= 0 {
            if let gun = soldier.weapon {
                if gun.canFire && canSee() {
                    cooldown = random(3, 5)
                    soldier.behavior.push(TemporaryBehavior(FireBehavior(soldier, 0.1), 1))
                }
            }
        }
    }
    
    func canSee() -> Bool {
        return ActorUtility.hasLineOfSight(soldier)
    }
    
}

class HealBehavior: Behavior {
    
    var alive: Bool = true
    var entity: Entity
    var cooldown: Float
    var counter: Float
    var healee: Soldier?
    
    init(_ entity: Entity) {
        self.entity = entity
        cooldown = 0
        counter = 0
    }
    
    func update() {
        cooldown -= Time.delta
        counter += Time.delta
        if cooldown <= 0 {
            if counter >= 0.1 {
                heal(2.m)
                counter = 0
            }
        }
    }
    
    func heal(_ radius: Float) {
        var selectNew = false
        if let healee = self.healee, let shield = healee.health.shield, shield.percent >= 2 {
            selectNew = true
            cooldown = 2
        }
        if healee == nil {
            selectNew = true
        }
        if selectNew {
            healee = select(radius)
        }
        if let healee = healee, let shield = healee.health.shield {
            shield.points.increase(2)
            playIfNot("enemy-heal")
        }
    }
    
    func select(_ radius: Float) -> Soldier? {
        let actors = Map.current.getActors(rect: FixedRect(entity.transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier, let shield = soldier.health.shield, shield.percent < 2 {
                 return soldier
            }
        }
        return nil
    }
    
}

class GlideBehavior: Behavior {
    
    var alive: Bool = true
    var entity: Entity
    var speed: Float
    
    init(_ entity: Entity, _ speed: Float) {
        self.entity = entity
        self.speed = speed
    }
    
    func update() {
        if ActorUtility.spaceInFront(entity, float2(0.75.m, 0)) {
            entity.body.location.y += speed * Time.delta
        }
    }
    
}

















