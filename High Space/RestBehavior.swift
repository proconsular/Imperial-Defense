//
//  RestBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RestBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer: Float = 0
    let length: Float
    
    unowned let shield: ParticleShield
    
    init(_ length: Float, _ shield: ParticleShield) {
        self.length = length
        self.shield = shield
    }
    
    func activate() {
        active = true
        timer = length
        shield.set(CollapseEffect(timer))
    }
    
    func update() {
        timer -= Time.delta
        if timer <= 0 {
            active = false
        }
    }
}
