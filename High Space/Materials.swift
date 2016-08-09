//
//  Platform.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/2/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Platform: Being {
    
    let location: float2
    let length: Float
    
    var thrust: Float
    
    init(_ location: float2, _ bounds: float2) {
        self.location = location + bounds / 2
        self.length = bounds.x
        thrust = 2.5.m * Float(Int(bounds.x / 3.5.m) + 1)
        
        super.init()
        
        setupBody(bounds)
    }
    
    private func setupBody(bounds: float2) {
        body = Body(Rect(Transform(self.location), bounds), Substance(Material(.Static), Mass.fixed(2.5), Friction(.Ice)))
        let coord = TextureLayout(generateTextureCoordinates(float2(), float2(-(bounds.x / 128) * (1 / kScale.y), 1)))
        visual = Visual(VisualRectScheme(self.location, bounds, coord, "platform_base"))
        body.tag = "Platform"
    }
    
    var right: Float {
        return body.location.x + length / 2
    }
    
    var top: float2 {
        return body.location - float2(0, body.shape.getBounds().bounds.y / 2)
    }
    
    override func update(processedTime: Float) {
        body.velocity.y += -12.m * processedTime
        if body.location.y > location.y {
            body.velocity.y += -thrust * processedTime
        }
        if body.location.y < location.y {
            body.velocity.y += 4.m * processedTime
        }
        
        if body.location.x < location.x {
            body.velocity.x += 1.m * processedTime
        }
        if body.location.x > location.x {
            body.velocity.x += -1.m * processedTime
        }
    }
    
}

class Floor: Being {
    
    init(_ location: float2, _ bounds: float2, _ color: float4) {
        super.init(location, bounds, getTexture("white"))
        let scheme = visual.scheme as! VisualScheme
        scheme.info.color = color
        body.substance.mass = Mass.Immovable
        body.tag = "Floor"
    }
    
}