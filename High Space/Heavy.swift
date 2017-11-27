//
//  Heavy.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Heavy: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(50, Shield(Float(50), Float(0.5), Float(50))), float4(1), "Heavy")
        let firer = Firer(1.5, Impact(30, 10.m), Casing(float2(0.5.m, 0.14.m) * 1.1, float4(1, 0, 1, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-heavy"))
        behavior.base.append(HeavyController(self))
    }
    
}
