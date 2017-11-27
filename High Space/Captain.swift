//
//  Captain.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Captain: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(60), Float(0.75), Float(50))), float4(1), "Captain")
        let firer = Firer(1.0, Impact(20, 10.m), Casing(float2(0.5.m, 0.13.m), float4(1, 0.5, 1, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        canSprint = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(CaptainController(self))
    }
    
}
