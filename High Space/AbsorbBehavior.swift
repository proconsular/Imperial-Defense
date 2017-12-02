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
    
    let rate: Float
    var timer: Float = 0
    var power: Float = 0
    var counter: Float = 0
    
    init(_ soldier: Soldier, _ radius: Float, _ rate: Float) {
        self.soldier = soldier
        self.radius = radius
        self.rate = rate
    }
    
    func activate() {
        timer = rate
    }
    
    func update() {
        timer -= Time.delta
        counter += Time.delta
        if timer >= 0 {
            if counter >= 0.5 {
                counter = 0
                steal(5)
            }
        }
    }
    
    func steal(_ amount: Float) {
        Map.current.apply(FixedRect(soldier.transform.location, float2(radius)), { [unowned self] (actor) in
            if let soldier = actor as? Soldier {
                if let shield = soldier.health.shield {
                    if shield.points.amount >= amount {
                        shield.damage(amount)
                        self.power += amount
                    }
                }
            }
        })
    }
}
