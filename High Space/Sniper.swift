//
//  Sniper.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(60), Float(0.5), Float(60))), float4(1), "Sniper")
        let firer = Firer(1.25, Impact(15, 25.m), Casing(float2(0.7.m, 0.15.m), float4(1, 0.5, 0.25, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.4.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-snipe"))
        //behavior.base.append(DodgeBehavior(self, 0.7))
    }
    
    override func update() {
        super.update()
        if let player = Player.player {
            weapon?.direction = normalize(player.transform.location - transform.location)
        }
    }
    
}
