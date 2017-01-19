//
//  Wall.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Wall: Structure {
    
    var health: Int
    var max: Int
    
    init(_ location: float2) {
        health = 25 + Data.info.barrier.computeAmount()
        max = health
        super.init(location, float2(0.2.m))
        display.texture = GLTexture("castle").id
        display.scheme.layout.coordinates = [float2(0, 0), float2(0.25, 0), float2(0.25, 0.25), float2(0, 0.25)]
        display.color = float4(1, 1, 1, 1)
        body.object = self
        body.mask = 0b1
    }
    
    override func update() {
        let percent = Float(health) / Float(max)
        display.color = float4(percent, percent, percent, 1)
        display.visual.refresh()
        if health <= 0 {
            alive = false
        }
    }
    
}

class Barrier {
    
    var walls: [Wall]
    
    init(_ location: float2, _ size: int2) {
        walls = []
        for i in 0 ..< size.x {
            for n in 0 ..< size.y {
                let wall = Wall(float2(location.x - Float(size.x) / 2 * 0.2.m + Float(i) * 0.2.m, location.y + Float(n) * 0.2.m))
                walls.append(wall)
                Map.current.append(wall)
            }
        }
    }
    
}
