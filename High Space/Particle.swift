//
//  Particle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/13/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Particle: Entity {
    
    var opacity: Float = 1
    var rate: Float = 1
    var color: float4 = float4(1)
    
    init(_ location: float2, _ size: Float) {
        let rect = Rect(Transform(location), float2(size))
        super.init(rect, rect, Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        display.scheme.schemes[0].order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        display.color = float4(opacity) * color
    }
    
    override func render() {
        display.visual.refresh()
        super.render()
    }
    
}

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
        display.scheme.schemes[0].order = 2
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity *= rate
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        circle.setRadius(radius * (1 - opacity))
        display.color = float4(opacity) * color
    }
    
    override func render() {
        display.visual.refresh()
        super.render()
    }
    
}

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
        display.scheme.schemes[0].order  = 1
        body.noncolliding = true
        //display = text.text.display.display
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= FLT_EPSILON {
            alive = false
        }
        text.text.display.color = color * float4(opacity)
    }
    
    override func render() {
        text.text.display.refresh()
        text.render()
    }
    
}


















