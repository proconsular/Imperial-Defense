//
//  Atlas.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/5/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Atlas {
    
    let texture: Texture
    let data: [String: AnyObject]
    let bounds: float2
    
    var textures: [String: AtlasTexture]
    
    init (_ name: String, _ highres: Bool = false) {
        if highres {
            texture = GLTextureLoader.fetch(name, UInt32(GL_RGBA8))
        }else{
            texture = GLTextureLoader.fetch(name)
        }
        
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
        data = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        let dict = data["meta"] as! [String: AnyObject]
        bounds = float2(dict["width"]! as! Float, dict["height"]! as! Float) * kScale
        
        textures = [:]
        let frames = data["frames"] as! [String: AnyObject]
        for (name, _) in frames {
            textures.updateValue(AtlasTexture(name, self), forKey: name)
        }
    }
    
    func bind() {
        glBindTexture(UInt32(GL_TEXTURE_2D), texture.texture)
    }
    
    func act() {
        
    }
    
}

class AtlasTexture {
    
    unowned let atlas: Atlas
    let info: [String: Float]
    let location, bounds: float2
    private(set) var coordinates: [float2]
    
    init (_ name: String, _ atlas: Atlas) {
        self.atlas = atlas
        let frames = atlas.data["frames"] as! [String: AnyObject]
        info = frames[name] as! [String: Float]
        location = float2(info["x"]!, info["y"]!) * kScale
        bounds = float2(info["w"]!, info["h"]!) * kScale
        coordinates = []
        coordinates = computeCoordinates()
    }
    
    private func computeCoordinates () -> [float2] {
        var coordinates: [float2] = []
        
        coordinates.append(float2(location.x / atlas.bounds.x, location.y / atlas.bounds.y))
        coordinates.append(float2((location.x + bounds.x) / atlas.bounds.x, location.y / atlas.bounds.y))
        coordinates.append(float2(location.x / atlas.bounds.x, (location.y + bounds.y) / atlas.bounds.y))
        coordinates.append(float2((location.x + bounds.x) / atlas.bounds.x, (location.y + bounds.y) / atlas.bounds.y))
        
        return coordinates
    }
    
    func computeAdjustedCoordinates() -> [float2] {
        var coordinates: [float2] = []
        
        coordinates.append(float2(1, 0))
        coordinates.append(float2(0, 0))
        coordinates.append(float2(0, 1))
        coordinates.append(float2(1, 1))
        
        for i in 0 ..< coordinates.count {
            coordinates[i] = (location + coordinates[i] * bounds) / atlas.bounds
        }
        
        return coordinates >> 3
    }
    
}