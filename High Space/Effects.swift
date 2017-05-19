//
//  ShieldEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Effect {
    func update()
}

class AbsorbEffect: Effect {
    
    var amount: Int
    var size: Float
    var rate: Float
    var radius: Float
    var color: float4
    var speed: Float
    
    var counter: Float
    
    var transform: Transform
    var particles: [Particle]
    
    init(_ amount: Int, _ rate: Float, _ radius: Float, _ size: Float, _ color: float4, _ speed: Float, _ transform: Transform) {
        self.amount = amount
        self.rate = rate
        self.radius = radius
        self.size = size
        self.color = color
        self.speed = speed
        self.transform = transform
        particles = []
        counter = 0
    }
    
    func update() {
        particles = particles.filter{ $0.alive }
        
        for p in particles {
            let dl = transform.location - p.transform.location
            let dir = dl / dl.length
            p.body.velocity += dir * speed
            if dl.length <= 0.1.m {
                p.alive = false
            }
        }
    }
    
    func generate() {
        counter += Time.delta
        if counter >= rate {
            counter = 0
            spawn(amount)
        }
    }
    
    func spawn(_ amount: Int) {
        for _ in 0 ..< amount {
            let location = transform.location + float2(random(-radius, radius), random(-radius, radius))
            let particle = Particle(location, size)
            let dl = transform.location - location
            let direction = dl / dl.length
            particle.body.velocity = direction * 0.1.m
            particle.color = color
            particles.append(particle)
            Map.current.append(particle)
        }
    }
    
}
