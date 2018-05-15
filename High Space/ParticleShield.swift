//
//  ParticleShield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleShield {
    
    let transform: Transform
    let radius: Float
    var power: Float
    
    var dilation: Float
    var spawning: Bool
    
    var speed: Float
    var drag: Float
    
    var enabled: Bool
    
    var energy: [Energy]
    
    var effect: ParticleShieldEffect?
    
    init(_ transform: Transform, _ radius: Float) {
        self.transform = transform
        self.radius = radius
        power = 100
        dilation = 1
        spawning = true
        speed = 0.5
        drag = 0.925
        energy = []
        enabled = true
    }
    
    func update() {
        if !enabled { return }
        
        energy = energy.filter{ $0.alive }
        if spawning {
            spawn()
        }
        animate()
        if let e = effect {
            e.update()
            if !e.alive {
                effect = nil
            }
        }
    }
    
    func set(_ effect: ParticleShieldEffect) {
        self.effect = effect
        self.effect!.shield = self
        self.effect!.use()
    }
    
    func animate() {
        for e in energy {
            let dl = e.transform.location - transform.location
            let angle = atan2f(dl.y, dl.x) + 1
            let loc = float2(cosf(angle), sinf(angle)) * radius * dilation
            let da = (transform.location + loc) - e.transform.location
            e.body.velocity += da * speed
            e.body.velocity *= drag
        }
    }
    
    func spawn() {
        let angle = random(-Float.pi, Float.pi)
        let en = Energy(float2(cosf(angle), sinf(angle)) * radius + transform.location, random(3, 5))
        
        let color = float4(0.75, 0.85, 1, 1)
        en.color = color
        en.material.color = color
        en.material.order = 201
        en.rate = 0.25
        
        energy.append(en)
        Map.current.append(en)
    }
    
}
