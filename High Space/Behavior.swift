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
    
    init(_ weapon: Weapon, _ soldier: Soldier) {
        self.weapon = weapon
        self.soldier = soldier
    }
    
    func update() {
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
            let s = Audio("shoot3")
            s.volume = sound_volume
            s.start()
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
            let s = Audio("shoot3")
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
