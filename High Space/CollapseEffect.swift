//
//  CollapseEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class CollapseEffect: ParticleShieldEffect {
    var alive: Bool = true
    
    let length: Float
    var timer: Float
    
    weak var shield: ParticleShield!
    
    init(_ length: Float) {
        self.length = length
        timer = 0
    }
    
    func use() {
        shield.spawning = false
        shield.drag = 0.95
    }
    
    func update() {
        timer += Time.delta
        if timer >= length {
            shield.reset()
            alive = false
        }
        shield.drag = clamp(shield.drag - 0.1 * Time.delta, min: 0.9, max: 1)
        shield.dilation = clamp(shield.dilation - 8 * Time.delta, min: 0, max: 1)
        for e in shield.energy {
            let dl = e.transform.location - shield.transform.location
            e.material.color *= dl.length / 2.m
            if dl.length <= 0.1.m {
                e.alive = false
            }
        }
    }
}
