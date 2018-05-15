//
//  InvulnerableBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class AbsorbBehavior: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    let radius: Float
    
    var timer: Float = 0
    var counter: Float = 0
    
    var battery: Battery
    
    var drain: VortexDrainEffect
    
    init(_ soldier: Soldier, _ battery: Battery, _ radius: Float) {
        self.soldier = soldier
        self.radius = radius
        self.battery = battery
        drain = VortexDrainEffect(soldier)
    }
    
    func update() {
        drain.update()
        counter += Time.delta
        if counter >= 0.05 {
            counter = 0
            steal(0.5)
        }
    }
    
    func steal(_ amount: Float) {
        Map.current.apply(FixedRect(soldier.transform.location, float2(radius)), { [unowned self] (actor) in
            if let soldier = actor as? Soldier, soldier !== self.soldier {
                if let shield = soldier.health.shield {
                    if shield.points.amount >= amount {
                        shield.damage(amount)
                        self.battery.amount += amount * 4
                        self.drain.append(soldier)
                    }
                }
            }
        })
    }
}
