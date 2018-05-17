//
//  ExplosionMaterial.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ExplosionMaterial: Material {
    unowned let explosion: Explosion
    
    init(_ explosion: Explosion) {
        self.explosion = explosion
        super.init()
        self["color"] = float4(1)
    }
    
    override func bind() {
        let shader = Graphics.bind(6)
        shader.setProperty("color", vector4: self["color"] as! float4)
        shader.setProperty("location", vector2: transform(explosion.transform.location))
        shader.setProperty("radius", value: explosion.radius)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
    
    func transform(_ location: float2) -> float2 {
        var l = float2()
        if let cam = Camera.current {
            l = cam.transform.location
        }
        let t = location - l
        let height = Float(UIScreen.main.bounds.height * UIScreen.main.scale)
        let scale: Float = Float(1125 / height)
        let s: Float = (height - 750) / (1125 - 750)
        let m: Float = 1 - 0.04 * clamp(s, min: 0, max: 1)
        return float2(t.x, Camera.size.y - t.y) * float2(1 / scale) * float2(m)
    }
}
