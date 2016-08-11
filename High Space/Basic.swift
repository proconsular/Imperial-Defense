//
//  Basic.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Basic {
    let display: Display
    
    init(_ display: Display) {
        self.display = display
    }
}

class Actor: Basic {
    let transform: Transform
    let body: Body
    
    init(_ hull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        body = Body(hull, substance)
        super.init(Display(hull, GLTexture("white")))
    }
}

class Structure: Actor {
    
    init(_ location: float2, _ bounds: float2) {
        super.init(Rect(location, bounds), Substance.Solid)
        display.scheme.info.color = float4(0.2, 0, 0, 1)
    }
    
}

class Player: Actor, Interface {
    
    init(_ location: float2) {
        super.init(Rect(location, float2(0.5.m, 1.m)), Substance.getStandard(0.3))
    }
    
    func use(command: Command) {
        if case .Vector(let force) = command {
            body.velocity += force / 20
        }
        if case .Pressed = command {
            body.velocity.y -= 200
        }
    }
    
}

class RenderLayer {
    var displays: [Display]
    
    init() {
        displays = []
    }
    
    func render() {
        displays.forEach{ $0.render() }
    }
}

class RenderMaster {
    var layers: [RenderLayer]
    
    init() {
        layers = []
    }
    
    func render() {
        layers.forEach{ $0.render() }
    }
}