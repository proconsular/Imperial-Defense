//
//  VortexDrainEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class VortexDrainEffect: VisualEffect {
    unowned let reciever: Soldier
    var targets: [Soldier]
    var energy: [Particle]
    
    var timer: Float = 0
    
    init(_ reciever: Soldier) {
        self.reciever = reciever
        targets = []
        energy = []
    }
    
    func append(_ target: Soldier) {
        for t in targets {
            if t === target {
                return
            }
        }
        targets.append(target)
    }
    
    func update() {
        targets = targets.filter{ $0.alive }
        
        timer += Time.delta
        if timer >= 0.05 {
            timer = 0
            drain()
        }
        
        energy = energy.filter{ $0.alive }
        
        for part in energy {
            let dl = reciever.transform.location - part.transform.location
            let nor = normalize(dl)
            let normal = float2(nor.y, -nor.x)
            let target = normal * 1.25.m + nor * 3.m
            part.body.velocity += target / 6
            part.body.velocity *= 0.9
        }
    }
    
    func drain() {
        for target in targets {
            let particle = Particle(target.transform.location + float2(random(-0.25.m, 0.25.m), random(-0.5.m, 0.5.m)), random(3, 5))
            energy.append(particle)
            particle.color = float4(1, 0.5, 0.5, 1)
            particle.rate = 1.25
            Map.current.append(particle)
        }
    }
}
