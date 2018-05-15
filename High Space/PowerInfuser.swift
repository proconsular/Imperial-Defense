//
//  PowerInfuser.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PowerInfuser: Entity {
    
    var timer: Float = 10
    
    init(_ location: float2) {
        let circle = Circle(Transform(location), 0.01.m)
        super.init(circle, circle, Substance.getStandard(0.1))
        body.noncolliding = true
    }
    
    override func update() {
        for _ in 0 ..< 3 {
            spawn()
        }
        timer -= Time.delta
        if timer <= 0 {
            alive = false
        }
    }
    
    func spawn() {
        let p = Particle(transform.location, random(4, 7))
        let range = 30.m
        p.body.velocity = float2(random(-range, range), random(-range, range))
        p.rate = 0.75
        p.drag = float2(0.9)
        let color = float4(0.75, 0.85, 1, 1)
        p.color = color
        p.material.color = color
        p.guider = FollowGuider(p.body, Player.player.transform, 1.5.m)
        Map.current.append(p)
    }
    
}
