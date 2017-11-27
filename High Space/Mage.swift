//
//  Mage.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Mage: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(40), Float(0.1), Float(60))), float4(1), "Mage")
        let firer = HomingFirer(1, Impact(30, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player", 2))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material.coordinates = SheetLayout(0, 12, 3).coordinates
        //        display.refresh()
        
        behavior.base.append(GlideBehavior(self, 0.25.m))
        behavior.base.append(DodgeBehavior(self, 0.4))
        behavior.base.append(HomingShootBehavior(weapon!, self, Player.player))
    }
    
    override func update() {
        super.update()
        material.coordinates = SheetLayout(0, 12, 3).coordinates
    }
    
}
