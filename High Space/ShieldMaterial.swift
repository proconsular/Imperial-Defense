//
//  Techniques.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/17/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ShieldMaterial: Material {
    
    var shield: Shield
    var transform: Transform
    var color: float4
    var height: Float
    var lastDamage: Float = 0
    var opacity: Float = 1
    
    var overlay_color: float4
    var overlay: Bool = false
    
    init(_ shield: Shield, _ transform: Transform, _ color: float4, _ height: Float) {
        self.shield = shield
        self.transform = transform
        self.color = color
        self.height = height
        overlay_color = float4(1)
        super.init()
    }
    
    override func bind() {
        let red = float4(1, 0, 0, 1)
        let green = float4(0, 1, 0, 1)
        
        let lost = shield.percent < lastDamage
        let gain = shield.percent > lastDamage
        lastDamage = shield.percent
        
        if lost {
            opacity = 0
        }
        
        if gain {
            opacity = 2
        }
        
        if opacity > 1 {
            opacity = clamp(opacity - Time.delta, min: 1, max: 2)
        }else if opacity < 1 {
            opacity = clamp(opacity + Time.delta, min: 0, max: 1)
        }
        
        if abs(1 - opacity) < Float.ulpOfOne {
            opacity = 1
        }
        
        let blend = (1 - opacity) * red + (opacity - 1) * green + color * opacity
        
        var output_color = float4(blend.x, blend.y, blend.z, 1) * float4(0.2 * shield.percent + 0.3)
        
        if overlay {
            output_color = overlay_color
        }
        
        let shader = Graphics.bind(2)
        
        shader.setProperty("color", vector4: output_color)
        shader.setProperty("location", vector2: transform(transform.location))
        shader.setProperty("level", vector2: transform(transform.location - float2(0, height * shield.percent - height / 2)))
        
        glBindTexture(GLenum(GL_TEXTURE_2D), self["texture"] as! GLuint)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(0, Camera.size.y, 0))
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

















