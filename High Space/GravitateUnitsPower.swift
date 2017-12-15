//
//  GravitateUnitsPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/13/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GravitateUnitsPower: TimedUnitPower {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        soldier.behavior.base.append(TemporaryBehavior(PullUnitsBehavior(soldier.transform, 5.m), 0.1))
    }
    
}

class PullUnitsBehavior: Behavior {
    var alive: Bool = true
    
    unowned let transform: Transform
    let radius: Float
    
    init(_ transform: Transform, _ radius: Float) {
        self.transform = transform
        self.radius = radius
    }
    
    func update() {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                let dl = transform.location - soldier.transform.location
                if length(dl) <= radius && length(dl) >= 1.m {
                    soldier.transform.location += dl / 1.m
                }
            }
        }
    }
}
