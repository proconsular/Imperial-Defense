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
    
    init(_ shield: Shield, _ transform: Transform, _ color: float4, _ height: Float) {
        self.shield = shield
        self.transform = transform
        self.color = color
        self.height = height
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
        
        let shader = Graphics.bind(2)
        
        shader.setProperty("color", vector4: float4(blend.x, blend.y, blend.z, 1) * float4(0.2 * shield.percent + 0.3))
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
        return float2(t.x, Camera.size.y - t.y) * float2(0.96, 0.96)
    }
    
}

//class BlurTechnique: RenderTechnique {
//    
//    var transform: Transform
//    var target: RenderTexture
//    var display: Display!
//    
//    var procedure: () -> ()
//    
//    init(_ transform: Transform, _ bounds: float2, _ procedure: @escaping () -> ()) {
//        self.transform = transform
//        self.procedure = procedure
//        target = RenderTexture(Int(bounds.x), Int(bounds.y))
//        display = Display(Rect(transform, bounds), GLTexture(target.texture.id))
////        material.coordinates = [float2(0, 1), float2(0, 0), float2(1, 0), float2(1, 1)]
//    }
//    
//    func render(_ visual: Render) {
//        let scheme = (visual.scheme as! VisualSchemeGroup).schemes[0]
//        
//        let rect = scheme.hull as! Rect
//        
//        let bounds = rect.bounds
//        
//        rect.setBounds(float2(Camera.size.x, Camera.size.y))
//        
//        let location = transform.location
//        
//        transform.location = float2(Camera.size.x / 2, -Camera.size.y / 2)
//        
//        target.capture {
//            procedure()
//        }
//        
//        rect.setBounds(bounds)
//        transform.location = location
//        
//        display.refresh()
//        display.render()
//        
//        let bloom = Graphics.bind(3)
//        bloom.setProperty("color", vector4: float4(1, 1, 1, 1))
//        bloom.setProperty("size", intvalue: 3)
//        bloom.setProperty("quality", value: 0.075)
//        
//        display.render()
//        
//        Graphics.bindDefault()
//    }
//    
//}



















