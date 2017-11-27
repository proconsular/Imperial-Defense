//
//  BulletTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct Impact {
    var damage: Float
    var speed: Float
    
    init(_ damage: Float, _ speed: Float) {
        self.damage = damage
        self.speed = speed
    }
    
}

struct Casing {
    var size: float2
    var color: float4
    var index: Int = -1
    var tag: String
    
    init(_ size: float2, _ color: float4, _ tag: String, _ index: Int = -1) {
        self.size = size
        self.color = color
        self.tag = tag
        self.index = index
    }
}
