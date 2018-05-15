//
//  AbsorbEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class AbsorbEffect: Effect {
    
    var amount: Int
    var size: Float
    var rate: Float
    var radius: Float
    var color: float4
    var speed: Float
    
    var counter: Float
    
    unowned var body: Body
    var particles: [Particle]
    
    init(_ amount: Int, _ rate: Float, _ radius: Float, _ size: Float, _ color: float4, _ speed: Float, _ body: Body) {
        self.amount = amount
        self.rate = rate
        self.radius = radius
        self.size = size
        self.color = color
        self.speed = speed
        self.body = body
        particles = []
        counter = 0
    }
    
    func update() {
        particles = particles.filter{ $0.alive }
        
        for p in particles {
            let dl = body.location - p.transform.location
            p.body.velocity += normalize(dl) * speed
            p.body.velocity *= 0.95
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
            let location = body.location + float2(random(-radius, radius), random(-radius, radius))
            let particle = Particle(location, size)
            let dl = body.location - location
            let direction = dl / dl.length
            particle.body.velocity = direction * 0.1.m
            particle.color = color
            particle.material.color = color
            particles.append(particle)
            Map.current.append(particle)
        }
    }
    
}
