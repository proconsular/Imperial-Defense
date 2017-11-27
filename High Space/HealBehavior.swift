//
//  HealBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HealBehavior: Behavior {
    
    var alive: Bool = true
    unowned var entity: Entity
    var cooldown: Float
    var counter: Float
    weak var healee: Soldier?
    
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
