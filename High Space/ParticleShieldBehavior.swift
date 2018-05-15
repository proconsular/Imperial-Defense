//
//  ParticleShieldBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleShieldBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    unowned let shield: ParticleShield
    
    var timer: Float = 0
    
    init(_ shield: ParticleShield) {
        self.shield = shield
    }
    
    func activate() {
        shield.set(DefendEffect(3))
        active = true
    }
    
    func update() {
        timer += Time.delta
        if timer >= 3 {
            timer = 0
            active = false
        }
    }
}
