//
//  Display.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Render {
    func refresh()
    func render()
}

protocol RenderTechnique {
    func render(_ visual: Visual)
}

class DefaultTechnique: RenderTechnique {
    func render(_ visual: Visual) {
        visual.render()
    }
}

class Display: Render {
    let transform: Transform
    
    let scheme: VisualSchemeGroup
    let visual: Visual!
    
    var material: ClassicMaterial
    var technique: RenderTechnique = DefaultTechnique()
    
    init(_ hull: Hull, _ material: ClassicMaterial) {
        transform = hull.transform
        self.material = material
        scheme = VisualSchemeGroup([VisualScheme(hull, material)])
        visual = Visual(scheme)
    }
    
    convenience init(_ hull: Hull, _ texture: GLTexture) {
        self.init(hull, ClassicMaterial(texture))
    }
    
    init(_ location: float2, _ bounds: float2, _ texture: GLTexture) {
        let hull = Rect(location + float2(0, -GameScreen.size.y), bounds)
        transform = hull.transform
        material = ClassicMaterial(texture)
        scheme =  VisualSchemeGroup([VisualScheme(hull, material)])
        visual = Visual(scheme)
    }
    
    func refresh() {
        visual.refresh()
    }
    
    func render() {
        technique.render(visual)
    }
    
//    func flip(_ x: Float, _ y: Float) {
//        scheme.schemes[0].layout.flip(vector: float2(x, y))
//    }
    
    var order: Int {
        get { return scheme.schemes[0].order }
        set { scheme.schemes[0].order = newValue }
    }
    
    var coordinates: [float2] {
        get { return material.coordinates }
        set { material.coordinates = newValue }
    }
    
    var color: float4 {
        get { return material.color }
        set { material.color = newValue }
    }
    
    var camera: Bool {
        get { return scheme.schemes[0].camera }
        set { scheme.schemes[0].camera = newValue }
    }
    
    var texture: GLuint {
        get { return material.texture.id }
        set { material.texture.id = newValue }
    }
}

class Batch {
    
    var group: VisualSchemeGroup
    var visual: Visual!
    
    init() {
        group = VisualSchemeGroup([])
    }
    
    func append(_ scheme: VisualScheme) {
        group.schemes.append(scheme)
    }
    
    func compile() {
        group.schemes.sort{ $0.order < $1.order }
        visual = Visual(group)
    }
    
    var order: Int {
        return group.schemes[0].order
    }
    
    func render() {
        if visual == nil {
            compile()
        }
        visual.render()
    }
    
}







