//
//  Objects.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Collectible: Physical {
    
    static let atlas = Atlas("GameObjects")
    
    let object: Object
    
    init (_ location: float2, _ bounds: float2, _ name: String) {
        self.object = Object.box(location, bounds, Collectible.atlas.texture.texture)
        let texture = Collectible.atlas.textures[name]!
        //object.image.uploadData(generateTextureCoordinates(texture.location / texture.atlas.bounds, texture.bounds / texture.atlas.bounds).asFloatData(), forAttribute: GLKVertexAttrib.TexCoord0)
        object.body.layer = .Scenery
    }
    
    func getBody() -> Body {
        return object.body
    }
    
    func update(processedTime: Float) {
        
    }
    
    func display() {
        object.display()
    }
    
}

class Gear: Collectible {
    
    var red: Float
    var dir: Float
    var angle: Float = 0
    
    init(_ location: float2) {
        red = 0.5
        dir = 1
        
        super.init(location, float2(100, 100), "Gear")
        //object.image.setColor4(float4(0.8, 1, 1, 1))
        angle = random(-Float(M_PI), Float(M_PI))
    }
    
    override func update(processedTime: Float) {
        angle += 1.25 * Float(M_PI) * processedTime
        
        red += 3 * dir * processedTime
        if red <= 0 {
            red = 0
            dir = 1
        }
        if red > 0.75 {
            red = 0.75
            dir = -1
        }
    }
    
    override func display() {
        //object.image.setColor4(float4(red, 1, red, 1))
        Being.display(object.visual, object.body.location, angle)
    }
    
}