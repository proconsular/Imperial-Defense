//
//  Display.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Render {
    func render()
}

class Display: Render {
    let transform: Transform
    
    let scheme: VisualSchemeGroup
    let visual: Visual!
    
    init(_ hull: Hull, _ texture: GLTexture) {
        transform = hull.transform
        scheme = VisualSchemeGroup([VisualScheme(hull, VisualInfo(texture.id))])
        visual = Visual(scheme)
    }
    
    init(_ hull: Hull, _ texture: Texture) {
        transform = hull.transform
        scheme = VisualSchemeGroup([VisualScheme(hull, VisualInfo(texture.id))])
        visual = Visual(scheme)
    }
    
    init(_ location: float2, _ bounds: float2, _ texture: GLTexture) {
        let hull = Rect(location + float2(0, -GameScreen.size.y), bounds)
        transform = hull.transform
        scheme =  VisualSchemeGroup([VisualScheme(hull, VisualInfo(texture.id))])
        visual = Visual(scheme)
    }
    
    func refresh() {
        visual.refresh()
    }
    
    func render() {
        visual.render()
    }
    
    var order: Int {
        get { return scheme.schemes[0].order }
        set { scheme.schemes[0].order = newValue }
    }
    
    var coordinates: [float2] {
        get { return scheme.schemes[0].coordinates }
        set { scheme.schemes[0].layout.coordinates = newValue }
    }
    
    var color: float4 {
        get { return scheme.schemes[0].color }
        set { scheme.schemes[0].info.color = newValue }
    }
    
    var camera: Bool {
        get { return scheme.schemes[0].camera }
        set { scheme.schemes[0].camera = newValue }
    }
    
    var texture: GLuint {
        get { return scheme.schemes[0].texture }
        set { scheme.schemes[0].info.texture = newValue }
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







