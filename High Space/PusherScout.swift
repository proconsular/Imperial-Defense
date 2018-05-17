//
//  PusherScout.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PusherScout: Soldier {
    required init(_ location: float2) {
        super.init(location, Health(45, nil), float4(1), "ArmoredScout")
        let firer = Firer(0.75, Impact(15, 14.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        animator = BaseMarchAnimator(body, 0.03 + (Float(GameData.info.challenge) * -0.005), 26.m)
        animator.apply(material)
        
        animator.set(1)
        
        sprinter = true
        
        behavior.base.append(PushMarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-light"))
        
    }
}
