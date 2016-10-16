//
//  Wall.swift
//  Defender
//
//  Created by Chris Luttio on 10/10/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Wall: Structure {
    
    var health = 5
    
    init(_ location: float2) {
        super.init(location, float2(0.2.m))
        display.texture = GLTexture("stonefloor").id
        display.scheme.layout.coordinates = [float2(0, 0), float2(0.1, 0), float2(0.1, 0.1), float2(0, 0.1)]
        display.color = float4(1, 1, 1, 1)
        body.object = self
        body.mask = 0b1
    }
    
    override func update() {
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
