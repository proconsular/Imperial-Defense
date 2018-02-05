//
//  Charger.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/17/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Charger: Soldier {
    
    required convenience init(_ location: float2) {
        let shield = Shield(Float(30), Float(1.25), Float(20))
        let health = Health(150, shield)
        self.init(location, health, float4(1), "Charger")
        let firer = Firer(1, Impact(100, 16.m), Casing(float2(0.6.m, 0.14.m) * 1.25, float4(0, 0, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        terminator = EMP(transform)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}
