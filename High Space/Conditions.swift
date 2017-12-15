//
//  Conditions.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/4/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerAwayCondition: PowerCondition {
    unowned let transform: Transform
    let distance: Float
    
    init(_ transform: Transform, _ distance: Float) {
        self.transform = transform
        self.distance = distance
    }
    
    func isPassed() -> Bool {
        if let player = Player.player {
            let dx = player.transform.location.x - transform.location.x
            if fabsf(dx) > distance {
                return true
            }
        }
        return false
    }
}

class ThreatenedCondition: PowerCondition {
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func isPassed() -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(1.m, 4.m)))
        for actor in actors {
            if let bullet = actor as? Bullet {
                if bullet.casing.tag == "enemy" {
                    return true
                }
            }
        }
        return false
    }
    
}

class LineOfSightCondition: PowerCondition {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func isPassed() -> Bool {
        return ActorUtility.hasLineOfSight(soldier)
    }
}

class BatteryChargedCondition: PowerCondition {
    unowned let battery: Battery
    let amount: Float
    
    init(_ battery: Battery, _ amount: Float) {
        self.battery = battery
        self.amount = amount
    }
    
    func isPassed() -> Bool {
        return battery.amount >= amount
    }
}





















