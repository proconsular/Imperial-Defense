//
//  TextParticle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class TextParticle: Entity {
    var opacity: Float = 1
    var rate: Float = 2.5
    var color: float4 = float4(1)
    var text: Text
    
    init(_ location: float2, _ string: String, _ size: Float) {
        text = Text(string, FontStyle(defaultFont, float4(1), size))
        text.location = location + float2(0, Camera.size.y)
        let rect = Rect(Transform(location), float2(size))
        super.init(rect, rect, Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        material.order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        text.text.display.color = color * float4(opacity)
    }
    
    override func render() {
        text.text.display.refresh()
        text.render()
    }
}
