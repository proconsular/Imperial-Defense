//
//  Commander.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Commander: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(90), Float(0.5), Float(50))), float4(1), "Commander")
        let firer = Firer(1.0, Impact(30, 10.m), Casing(float2(0.7.m, 0.175.m), float4(1, 0.25, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        
    }
    
}
