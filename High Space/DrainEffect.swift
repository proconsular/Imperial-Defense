//
//  DrainEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DrainEffect: VisualEffect {
    unowned let reciever: Soldier
    weak var target: Soldier?
    
    var timer: Float = 0
    
    var energy: [Particle]
    
    init(_ reciever: Soldier) {
        self.reciever = reciever
        energy = []
    }
    
    func update() {
        timer += Time.delta
        if timer >= 0.01 {
            timer = 0
            
            if let target = target {
                drain(target.transform)
            }
        }
        
        energy = energy.filter{ $0.alive }
        
        for part in energy {
            let dl = (reciever.transform.location + float2(random(-0.25.m, 0.25.m), random(-0.5.m, 0.5.m))) - part.transform.location
            part.body.velocity += dl * 2
            part.body.velocity *= 0.5
        }
    }
    
    func drain(_ source: Transform) {
        let particle = Particle(source.location + float2(random(-0.25.m, 0.25.m), random(-0.5.m, 0.5.m)), random(3, 5))
        energy.append(particle)
        Map.current.append(particle)
    }
}
