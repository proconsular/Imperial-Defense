//
//  DefendEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DefendEffect: ParticleShieldEffect {
    var alive: Bool = true
    
    weak var shield: ParticleShield!
    
    let length: Float
    var timer: Float
    
    init(_ length: Float) {
        self.length = length
        timer = 0
    }
    
    func use() {
        shield.drag = 0.85
        shield.speed = 0.5
    }
    
    func update() {
        timer += Time.delta
        if timer >= length {
            shield.drag = 0.925
            shield.speed = 0.5
            alive = false
        }
    }
}
