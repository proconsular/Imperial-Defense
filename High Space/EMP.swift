//
//  ChargeTerminator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/17/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class EMP: ActorTerminationDelegate {
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func terminate() {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(4.m)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                let dl = transform.location - soldier.transform.location
                if dl.length <= 3.m {
                    soldier.health.shield = nil
                    soldier.shield_material = nil
                    if soldier.handle.materials.count > 1 {
                        soldier.handle.materials.removeLast()
                    }
                }
            }
        }
        let exp = Explosion(transform.location, 4.m)
        exp.color = float4(0, 0.5, 1, 1)
        Map.current.append(exp)
    }
    
}
