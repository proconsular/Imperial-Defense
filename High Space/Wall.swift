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
    
    init(_ location: float2, _ health: Int) {
        self.health = health
        max = health
        super.init(location, float2(64, 32) * 4)
        display.texture = GLTexture("barrier_castle").id
        display.color = float4(1, 1, 1, 1)
        body.object = self
        body.mask = 0b1
        display.scheme.schemes[0].order = -1
    }
    
    override func update() {
//        let percent = Float(health) / Float(max)
//        display.color = float4(percent, percent, percent, 1)
//        display.visual.refresh()
        if health <= 0 {
            alive = false
        }
    }
    
}
