//
//  MissileFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class MissilePower: TimedUnitPower {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ limit: Float) {
        self.soldier = soldier
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        soldier.stop(0.5) { [unowned soldier] in
            let direction = float2(0, 1)
            let location = soldier.transform.location + 0.75.m * direction + float2(-0.2.m, -0.7.m)
            let missile = Missile(location, direction, Casing(float2(0.4.m, 0.8.m), float4(1), "player"))
            Map.current.append(missile)
            Audio.play("missile", 0.2)
        }
    }
    
}
