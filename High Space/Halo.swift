//
//  Halo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Halo: Entity {
    var opacity: Float = 1
    var radius: Float
    var color: float4 = float4(1)
    var rate: Float = 0.75
    
    init(_ location: float2, _ radius: Float) {
        self.radius = radius
        let circle = Rect(Transform(location), float2(radius))
        super.init(circle, circle, Substance.getStandard(1))
        body.mask = 0b0
        material["order"] = 2
        material["texture"] = GLTexture("Halo").id
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity *= rate
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        material["color"] = float4(opacity) * color
    }
}
