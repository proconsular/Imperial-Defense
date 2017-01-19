//
//  Scheme.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Scheme {
    func getRawScheme() -> RawScheme
}

class VisualScheme: Scheme {
    var hull: Hull
    var layout: TextureLayout
    var info: VisualInfo
    var camera: Bool
    
    init(_ hull: Hull, _ layout: TextureLayout, _ info: VisualInfo) {
        self.hull = hull
        self.layout = layout
        self.info = info
        camera = true
    }
    
    convenience init(_ hull: Hull, _ info: VisualInfo) {
        self.init(hull, TextureLayout(hull), info)
    }
    
    func getRawScheme() -> RawScheme {
        return RawVisualScheme(self)
    }
    
    var vertices: [float2] {
        get { return hull.getVertices() }
        set {
            if let rect = hull as? Rect {
                rect.form.vertices = newValue
            }
        }
    }
    
    var coordinates: [float2] {
        return layout.coordinates
    }
    
    var color: float4 {
        return info.color
    }
    
    var texture: UInt32 {
        return info.texture
    }
}

class VisualRectScheme: VisualScheme {
    
    init(_ location: float2, _ bounds: float2, _ layout: TextureLayout, _ texture: VisualInfo) {
        let rect = Rect(Transform(location), bounds)
        super.init(rect, layout, texture)
    }
    
    init(_ location: float2, _ bounds: float2, _ layout: TextureLayout, _ texture: String) {
        let rect = Rect(Transform(location), bounds)
        super.init(rect, layout, VisualInfo(0))
    }
    
    convenience init(_ location: float2, _ bounds: float2, _ texture: String) {
        let rect = Rect(Transform(location), bounds)
        self.init(location, bounds, TextureLayout(rect), texture)
    }
    
}

class VisualSchemeGroup: Scheme {
    var schemes: [VisualScheme]
    
    init(schemes: [VisualScheme]) {
        self.schemes = schemes
    }
    
    func getRawScheme() -> RawScheme {
        return RawVisualSchemeGroup(self)
    }
}
