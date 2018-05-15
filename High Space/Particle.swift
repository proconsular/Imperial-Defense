//
//  Particle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/13/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Particle: Entity {
    
    let size: Float
    var opacity: Float = 1
    var rate: Float = 1
    var color: float4 = float4(1)
    var guider: Guider?
    var drag = float2(1)
    
    init(_ location: float2, _ size: Float) {
        self.size = size
        let rect = Point(Transform(location), size)
        super.init(rect, rect, Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        body.noncolliding = true
        handle.material = PointMaterial()
    }
    
    override func compile() {
        ParticleSystem.current.append(handle)
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        handle.material["color"] = float4(opacity) * color
        guider?.update()
        body.velocity *= drag
    }
    
}
















