//
//  Platform.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/2/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class PlatformAddon {
    let object: AtlasTexture
    var visual: VisualScheme!
    
    init(_ name: String) {
        object = Platform.atlas.textures[name]!
    }
    
    func setup(location: float2) {
        visual = VisualRectScheme(location, object.bounds, TextureLayout(object.computeAdjustedCoordinates()), VisualInfo(object.atlas.texture.texture))
    }
}

class Platform: Being {
    
    static let atlas = Atlas("Platform")
    
    var addons: VisualSchemeGroup
    var addons_visual: Visual!
    
    let location: float2
    let length: Float
    let engines: Int
    
    var thrust: Float
    
    init(_ location: float2, _ bounds: float2) {
        addons = VisualSchemeGroup(schemes: [])
        self.location = location + bounds / 2
        let width = 3.5.m
        length = bounds.x
        engines = Int(bounds.x / width) + 1
        
        thrust = 2.5.m * Float(engines)
        
        super.init()
        
        setupBody(bounds)
        setupAddons(bounds)
        setupEngines(bounds, width)
    }
    
    private func setupBody(bounds: float2) {
        body = Body(Rect(Transform(self.location), bounds), Substance(Material(.Static), Mass.fixed(2.5), Friction(.Ice)))
        let coord = TextureLayout(generateTextureCoordinates(float2(), float2(-(bounds.x / 128) * (1 / kScale.y), 1)))
        visual = Visual(VisualRectScheme(self.location, bounds, coord, "platform_base"))
        body.tag = "Platform"
    }
    
    private func setupAddons(bounds: float2) {
        let bottom_a = PlatformAddon("platform-piece-bottom")
        bottom_a.setup(float2(-bounds.x / 2 + bottom_a.object.bounds.x, bottom_a.object.bounds.y / 2 + 15))
        addons.schemes.append(bottom_a.visual)
        
        let right_a = PlatformAddon("platform-piece-right")
        right_a.setup(float2(bounds.x / 2 - right_a.object.bounds.x / 2 + 46, 0))
        addons.schemes.append(right_a.visual)
        
        let top_a = PlatformAddon("platform-piece-top")
        top_a.setup(float2(-(Float(random()) % top_a.object.bounds.x / 2) + top_a.object.bounds.x / 2, -top_a.object.bounds.y / 2 + 18))
        addons.schemes.append(top_a.visual)
        
        let left_a = PlatformAddon("platform-piece-left")
        left_a.setup(float2(-bounds.x / 2 + 6, 4))
        addons.schemes.append(left_a.visual)
        
        addons_visual = Visual(addons)
    }
    
    private func setupEngines(bounds: float2, _ width: Float) {
        let repulser = Platform.atlas.textures["Repulser-no-beam"]!
        let separation = bounds.x / (width * 1.5)
        for i in 0 ..< engines {
            let width = repulser.bounds.x * separation
            let half = width / 2
            let move = half * Float(engines - 1)
            let offset = Float(i) * width - move
            
            let e_t = Transform(float2(offset - repulser.bounds.x / 2, 0) + repulser.bounds / 2)
            let e_s = VisualScheme(Rect(e_t, repulser.bounds), TextureLayout(repulser.computeAdjustedCoordinates()), VisualInfo(Platform.atlas.texture.texture))
            addons.schemes.append(e_s)
        }
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
    
    override func display() {
        
        for scheme in addons.schemes {
            scheme.hull.transform.location += body.location - Camera.location
        }
        
        addons_visual.refresh()
        addons_visual.render()
        super.display()
        
        for scheme in addons.schemes {
            scheme.hull.transform.location += -(body.location - Camera.location)
        }
    }
    
}

class Floor: Being {
    
    init(_ location: float2, _ bounds: float2, _ color: float4) {
        super.init(location, bounds, getTexture("white"))
        let scheme = visual.scheme as! VisualScheme
        scheme.info.color = color
        //visual.refresh()
        body.substance.mass = Mass.Immovable
        body.tag = "Floor"
    }
    
}