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
    var material: ClassicMaterial
    var camera: Bool
    var order: Int
    
    init(_ hull: Hull, _ material: ClassicMaterial) {
        self.hull = hull
        self.material = material
        material.coordinates = HullLayout(hull).coordinates
        camera = true
        order = 0
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
        return material.coordinates
    }
    
    var color: float4 {
        return material.color
    }
    
    var texture: UInt32 {
        return material.texture.id
    }
}

//class VisualRectScheme: VisualScheme {
//    
//    init(_ location: float2, _ bounds: float2, _ layout: HullLayout, _ texture: VisualInfo) {
//        let rect = Rect(Transform(location), bounds)
//        super.init(rect, layout, texture)
//    }
//    
//    init(_ location: float2, _ bounds: float2, _ layout: HullLayout, _ texture: String) {
//        let rect = Rect(Transform(location), bounds)
//        super.init(rect, layout, VisualInfo(0))
//    }
//    
//    convenience init(_ location: float2, _ bounds: float2, _ texture: String) {
//        let rect = Rect(Transform(location), bounds)
//        self.init(location, bounds, HullLayout(rect), texture)
//    }
//    
//}

class VisualSchemeGroup: Scheme {
    var schemes: [VisualScheme]
    
    init(_ schemes: [VisualScheme]) {
        self.schemes = schemes
    }
    
    func getRawScheme() -> RawScheme {
        return RawVisualSchemeGroup(self)
    }
}
