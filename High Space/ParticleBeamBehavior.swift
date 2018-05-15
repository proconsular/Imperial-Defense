//
//  ParticleBeamBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleBeamBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var count: Float
    
    var radius: Float = 0
    var angle: Float = 0
    
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
        count = 0
    }
    
    func activate() {
        active = true
        count = 5
        radius = 0
        computeAngle()
    }
    
    func computeAngle() {
        let dl = Player.player.transform.location - transform.location
        angle = atan2(dl.y, dl.x)
    }
    
    func update() {
        radius += (12.5.m + random(0, 1.m)) * Time.delta
        
        for _ in 0 ..< 10 {
            let angle = self.angle + random(-0.2, 0.2)
            let p = DarkEnergy(transform.location + float2(cosf(angle), sinf(angle)) * radius, random(5, 8))
            p.rate = 2
            p.color = float4(0.75, 0.85, 1, 1)
            p.material.color = float4(0.75, 0.85, 1, 1)
            Map.current.append(p)
        }
        
        if radius >= Camera.size.x / 2 {
            radius = 0
            count -= 1
            computeAngle()
            if count < 0 {
                active = false
            }
        }
    }
}
