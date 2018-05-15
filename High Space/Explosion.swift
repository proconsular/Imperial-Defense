//
//  Explosion.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Explosion: Entity {
    var opacity: Float = 1
    var radius: Float
    var color: float4 = float4(1)
    var rate: Float = 0.75
    var circle: Circle
    
    init(_ location: float2, _ radius: Float) {
        self.radius = radius
        circle = Circle(Transform(location), 0)
        super.init(circle, circle, Substance.getStandard(1))
        body.mask = 0b0
        material["order"] = 2
        body.noncolliding = true
    }
    
    static func create(_ location: float2, _ radius: Float, _ color: float4) {
        let exp = Explosion(location, radius)
        exp.color = color
        Map.current.append(exp)
    }
    
    override func update() {
        super.update()
        opacity *= rate
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        circle.setRadius(radius * (1 - opacity))
        material["color"] = float4(opacity) * color
    }
}
