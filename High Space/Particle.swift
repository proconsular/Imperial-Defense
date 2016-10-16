//
//  Particle.swift
//  Defender
//
//  Created by Chris Luttio on 10/13/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Particle: Actor {
    
    var opacity: Float = 1
    var rate: Float = 1
    var color: float4 = float4(1)
    
    init(_ location: float2, _ size: Float) {
        super.init(Rect(Transform(location), float2(size)), Substance.getStandard(0.01))
        body.mask = 0b0
        order = 1
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.time
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= 0 {
            alive = false
        }
    }
    
    override func render() {
        display.color = float4(opacity) * color
        display.visual.refresh()
        super.render()
    }
    
}
