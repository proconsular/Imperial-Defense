//
//  Particle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/13/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Particle: Actor {
    
    var opacity: Float = 1
    var rate: Float = 1
    var color: float4 = float4(1)
    
    init(_ location: float2, _ size: Float) {
        super.init(Rect(Transform(location), float2(size)), Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.time
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= FLT_EPSILON {
            alive = false
        }
    }
    
    override func render() {
        display.color = float4(opacity) * color
        display.visual.refresh()
        super.render()
    }
    
}

class Explosion: Actor {
    
    var opacity: Float = 1
    var radius: Float
    var color: float4 = float4(1)
    var circle: Circle
    
    init(_ location: float2, _ radius: Float) {
        self.radius = radius
        circle = Circle(Transform(location), 0)
        super.init(circle, Substance.getStandard(1))
        body.mask = 0b0
        order = 2
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity *= 0.75
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= FLT_EPSILON {
            alive = false
        }
        circle.setRadius(radius * (1 - opacity))
    }
    
    override func render() {
        display.color = float4(opacity) * color
        display.visual.refresh()
        super.render()
    }
    
}

class TextParticle: Actor {
    
    var opacity: Float = 1
    var rate: Float = 2.5
    var color: float4 = float4(1)
    var text: Text
    
    init(_ location: float2, _ string: String, _ size: Float) {
        text = Text(string, FontStyle(defaultFont, float4(1), size))
        text.location = location + float2(0, Camera.size.y)
        super.init(Rect(Transform(location), float2(size)), Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.time
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= FLT_EPSILON {
            alive = false
        }
    }
    
    override func render() {
        text.text.display.color = color * float4(opacity)
        text.text.display.refresh()
        text.render()
    }
    
}


















