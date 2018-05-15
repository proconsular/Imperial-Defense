//
//  DarkBlast.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DarkBlast {
    
    let transform: Transform
    let radius: Float
    var life: Float
    var velocity: float2
    
    var energy: [DarkEnergy]
    
    init(_ location: float2, _ radius: Float, _ life: Float) {
        transform = Transform(location)
        self.radius = radius
        self.life = life
        velocity = float2()
        energy = []
    }
    
    func update() {
        transform.location += velocity * Time.delta
        velocity *= 0.98
        
        energy = energy.filter{ $0.alive }
        
        for _ in 0 ..< 5 {
            spawn()
        }
    }
    
    func spawn() {
        let angle = random(-Float.pi, Float.pi)
        let mag = random(0, radius)
        let loc = float2(cosf(angle), sinf(angle)) * mag
        let energy = DarkEnergy(loc + transform.location, random(6, 9))
        energy.color = float4(0.75, 0.85, 1, 1)
        energy.material.color = float4(0.75, 0.85, 1, 1)
        energy.rate = 1
        self.energy.append(energy)
        Map.current.append(energy)
    }
    
}
