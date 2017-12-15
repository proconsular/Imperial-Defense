//
//  GravitateFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GravitateFireBehavior: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    
    let radius: Float
    var polarity: Float = 1
    
    init(_ soldier: Soldier, _ radius: Float) {
        self.soldier = soldier
        self.radius = radius
    }
    
    func update() {
        let units = Map.current.getActors(rect: FixedRect(soldier.transform.location, float2(radius)))
        
        for unit in units {
            if let bullet = unit as? Bullet, bullet.casing.tag == "enemy" {
                let dl = soldier.transform.location - bullet.transform.location
                if length(dl) <= radius {
                    let len = length(dl)
                    bullet.body.velocity += (10000.m / (len * len)) * normalize(dl) * polarity
                }
            }
        }
    }
    
}

class DisruptFirePower: TimedUnitPower {
    
    unowned let soldier: Soldier
    let radius: Float
    
    init(_ soldier: Soldier, _ radius: Float, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.radius = radius
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        soldier.behavior.base.append(TemporaryBehavior(GravitateFireBehavior(soldier, radius), 2))
    }
    
}













