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

class BlastEffect {
    
    var transform: Transform
    var bounds: float2
    
    init(_ transform: Transform, _ bounds: float2) {
        self.transform = transform
        self.bounds = bounds
    }
    
    func generate() {
        let count = random(10, 20)
        for _ in 0 ..< Int(count) {
            spawn()
        }
    }
    
    func spawn() {
        let spark = Particle(transform.location + float2(random(-bounds.x / 2, bounds.x / 2), random(-bounds.y / 2, bounds.y / 2)), random(4, 9))
        let col = random(0.5, 0.75)
        spark.color = float4(col, col, col, 1)
        let velo: Float = 400
        spark.body.relativeGravity = 1
        spark.rate = 0.5
        spark.body.velocity = float2(random(-velo, velo) / 2, random(-velo, -velo / 2))
        Map.current.append(spark)
    }
    
}

















