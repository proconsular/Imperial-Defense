//
//  SprayFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SprayFireBehavior: CooldownBehavior {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ limit: Float) {
        self.soldier = soldier
        super.init(limit)
    }
    
    override var available: Bool {
        return super.available && ActorUtility.hasLineOfSight(soldier)
    }
    
    override func activate() {
        super.activate()
        soldier.behavior.push(TemporaryBehavior(EmptyBehavior(), 0.01) { [unowned soldier] in
            soldier.weapon!.direction = float2(0, 1)
        })
        for _ in 0 ..< 10 {
            soldier.behavior.push(TemporaryBehavior(EmptyBehavior(), 0.01) { [unowned soldier] in
                soldier.weapon!.direction = normalize(float2(random(-0.5, 0.5), 1))
            })
            soldier.behavior.push(TemporaryBehavior(FireBehavior(soldier, 0.1), 0.1) { [unowned soldier] in
                soldier.weapon!.fire()
            })
        }
        
    }
    
}
