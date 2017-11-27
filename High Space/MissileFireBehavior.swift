//
//  MissileFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class MissileFireBehavior: CooldownBehavior {
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
        soldier.stop(0.5) { [unowned soldier] in
            let direction = float2(0, 1)
            let location = soldier.transform.location + 0.75.m * direction + float2(-0.2.m, -0.7.m)
            let missile = Missile(location, direction, Casing(float2(0.4.m, 0.6.m), float4(1), "player"))
            Map.current.append(missile)
        }
    }
    
}
