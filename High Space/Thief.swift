//
//  Thief.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Thief: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(5, Shield(Float(30), Float(1.25), Float(20))), float4(1), "Thief")
        let firer = Firer(0.5, Impact(15, 12.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        animator.set(1)
        
        sprinter = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-light"))
    }
    
}
