//
//  EnergyStream.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyStream {
    let location, bounds: float2
    
    init(_ location: float2, _ bounds: float2) {
        self.location = location
        self.bounds = bounds
    }
    
    func update() {
        for _ in 0 ..< 2 {
            generate()
        }
    }
    
    func generate() {
        let particle = Particle(location + float2(0, random(-bounds.y / 2, bounds.y / 2)), random(2, 5))
        
        particle.body.velocity = float2(random(-6.m, -8.m), 0)
        particle.rate = random(0.1, 0.5)
        
        Map.current.append(particle)
    }
    
    func populate() {
        let particle = Particle(location + float2(random(-Camera.size.x, 0), random(-bounds.y / 2, bounds.y / 2)), random(2, 5))
        
        particle.body.velocity = float2(random(-6.m, -8.m), 0)
        particle.rate = random(0.1, 0.5)
        
        Map.current.append(particle)
    }
}
