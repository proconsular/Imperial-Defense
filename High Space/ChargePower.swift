//
//  ChargeBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ChargePower: TimedUnitPower {
    unowned let transform: Transform
    var radius: Float
    var duration: Float
    
    init(_ transform: Transform, _ radius: Float, _ duration: Float, _ cost: Float, _ limit: Float) {
        self.transform = transform
        self.radius = radius
        self.duration = duration
        super.init(cost, limit)
    }
    
    override func invoke() {
        super.invoke()
        Map.current.apply(FixedRect(transform.location, float2(radius))) { [unowned self] in
            if let soldier = $0 as? Soldier {
                soldier.behavior.push(Sprint(soldier, self.duration))
            }
        }
        Explosion.create(transform.location, radius, float4(1, 0, 0, 1))
        Audio.start("enemy-rush")
    }
}







