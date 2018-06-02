//
//  ParticleWaveBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleWaveBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var count: Int
    var frequency: Float
    
    var radius: Float = 0
    
    let speed: Float
    let amount: Int
    
    unowned let transform: Transform
    
    init(_ speed: Float, _ amount: Int, _ transform: Transform) {
        self.speed = speed
        self.amount = amount
        self.transform = transform
        count = 0
        frequency = 0
    }
    
    func activate() {
        active = true
        count = amount
        radius = 0
        
    }
    
    func update() {
        radius += speed * Time.delta
        
        if !Audio("particle_wave").playing {
            Audio.play("particle_wave", 0.5)
        }
        
        let amount = Int(10 + radius / 5.m + speed / 5.m)
        for i in 0 ..< amount {
            let percent = Float(i) / Float(amount)
            let angle = -Float.pi + 2 * Float.pi * percent + random(0, Float.pi)
            let p = DarkEnergy(transform.location + float2(cosf(angle), sinf(angle)) * radius, random(3, 7))
            p.rate = 1
            p.color = float4(0.75, 0.85, 1, 1)
            p.material.color = float4(0.75, 0.85, 1, 1)
            Map.current.append(p)
        }
        
        if radius >= Camera.size.x {
            radius = 0
            count -= 1
            if count < 0 {
                active = false
            }
        }
    }
}
