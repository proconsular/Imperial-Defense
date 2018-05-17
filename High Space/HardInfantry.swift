//
//  HardInfantry.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class HardInfrantry: Soldier {
    required convenience init(_ location: float2) {
        let shield = Shield(Float(45), Float(1.25), Float(20))
        let health = Health(45, shield)
        self.init(location, health, float4(1), "HardSoldier")
        let firer = Firer(1.5, Impact(45, 16.m), Casing(float2(0.6.m, 0.14.m), float4(1, 0, 0, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        canSprint = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
}
