//
//  Infantry.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StandardSoldier: Soldier {
    
    convenience init(_ location: float2) {
        let shield = Shield(Float(15), Float(1.5), Float(30))
        let health = Health(5, shield)
        
        self.init(location, health, float4(1))
        
        let firer = Firer(2, Impact(15, 8.m), Casing(float2(0.5.m, 0.14.m), float4(1, 0.25, 0, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}

class Infrantry: Soldier {
    
    required convenience init(_ location: float2) {
        let shield = Shield(Float(15), Float(1.25), Float(20))
        let health = Health(5, shield)
        self.init(location, health, float4(1))
        let firer = Firer(1.5, Impact(15, 12.m), Casing(float2(0.6.m, 0.14.m), float4(1, 0, 0, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        canSprint = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}
