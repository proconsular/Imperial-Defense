//
//  Behavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Behavior {
    var alive: Bool { get set }
    func update()
}

class ComplexBehavior: Behavior {
    
    var alive: Bool = true
    var behaviors: [Behavior]
    
    init() {
        behaviors = []
    }
    
    func update() {
        behaviors.forEach{
            $0.update()
        }
    }
    
    func append(_ behavior: Behavior) {
        behaviors.append(behavior)
    }
    
}

class SerialBehavior: Behavior {
    
    var alive: Bool = true
    var stack: Stack<Behavior>
    
    init() {
        stack = Stack<Behavior>()
    }
    
    func update() {
        let active = stack.peek!
        active.update()
        if !active.alive {
            stack.pop()
        }
    }
    
    var behavior: Behavior {
        return stack.peek!
    }
    
}

class SequencialBehavior<T: Behavior>: Behavior {
    var alive: Bool = true
    var behaviors: [T]
    var index: Int
    
    init() {
        behaviors = []
        index = 0
    }
    
    func update() {
        behaviors[index].update()
    }
    
}

class MarchBehavior: Behavior {
    
    var alive: Bool = true
    unowned let entity: Entity
    var animator: Animator
    
    init(_ entity: Entity, _ animator: Animator) {
        self.entity = entity
        self.animator = animator
    }
    
    func update() {
        if ActorUtility.spaceInFront(entity, float2(0.75.m, 0)) {
            animator.update()
            animator.apply(entity.display)
        }
    }
    
}

class ShootBehavior: Behavior {
    
    var alive: Bool = true
    var weapon: Weapon
    var soldier: Soldier
    var sound: String
    
    var charge_timer: Float = 0
    
    init(_ weapon: Weapon, _ soldier: Soldier, _ sound: String = "enemy-shoot") {
        self.weapon = weapon
        self.soldier = soldier
        self.sound = sound
    }
    
    func update() {
        if canSee() && !weapon.canFire {
            charge_timer += Time.delta
            if charge_timer >= 0.025 + 0.35 * (1 - weapon.firer.charge) {
                charge_timer = 0
                let range = 0.25.m
                let particle = Particle(weapon.firepoint + float2(random(-range, range), random(-range, range)), random(3, 6))
                particle.rate = 2.5 - 1 * weapon.firer.charge
                let col = float4(0.65, 0.5, 0.5, 1)
                particle.color = col
                particle.display.color = col
                let t = Transform(weapon.firepoint - soldier.transform.location)
                t.assign(soldier.transform)
                particle.guider = FollowGuider(particle.body, t, 0.1.m + 0.1.m * weapon.firer.charge)
                Map.current.append(particle)
            }
        }
        
        if shouldFire() && canSee() {
            fire()
        }
    }
    
    func shouldFire() -> Bool {
        let dl = Player.player.body.location - soldier.body.location
        let d = min(dl.x / 1.m, 1)
        let roll = (1 - d) * 0.2
        return random(0, 1) < (0.05 + roll)
    }
    
    func canSee() -> Bool {
        return ActorUtility.hasLineOfSight(soldier)
    }
    
    func fire() {
        if weapon.canFire {
            weapon.fire()
            let s = Audio(sound)
            s.volume = sound_volume
            s.start()
            for _ in 0 ..< 3 {
                let particle = Particle(weapon.firepoint, random(2, 4))
                particle.rate = 3.5
                let col = float4(0.85, 0.85, 0.85, 1)
                particle.color = col
                particle.display.color = col
                particle.body.velocity = weapon.direction * 2.5.m + float2(random(-1.m, 1.m), 0)
                Map.current.append(particle)
            }
        }
    }
    
}

class HomingShootBehavior: ShootBehavior {
    
    var target: Entity
    
    init(_ weapon: Weapon, _ soldier: Soldier, _ target: Entity) {
        self.target = target
        super.init(weapon, soldier)
    }
    
    override func fire() {
        if weapon.canFire && target.alive {
            if let weapon = weapon as? HomingWeapon {
                 weapon.fire(target)
            }
            let s = Audio("enemy-shoot-magic")
            s.volume = sound_volume
            s.start()
        }
    }
    
}

class TemporaryBehavior: Behavior {
    
    var alive: Bool = true
    var counter: Float
    var behavior: Behavior
    var onComplete: (() -> ())?
    
    init(_ behavior: Behavior, _ count: Float, _ onComplete: (() -> ())? = nil) {
        self.counter = count
        self.behavior = behavior
        self.onComplete = onComplete
    }
    
    func update() {
        behavior.update()
        counter -= Time.delta
        if counter <= 0 {
            alive = false
            onComplete?()
        }
    }
    
}
