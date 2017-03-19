//
//  Form.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Form {
    func getVertices() -> [float2]
}

class Edgeform: Form {
    var vertices: [float2] = []
    var normals: [float2] = []
    
    init(_ vertices: [float2]) {
        self.vertices = vertices.centered
        normals = computeNormals()
    }
    
    convenience init (_ bounds: float2) {
        self.init([float2(0), float2(0, bounds.y), bounds, float2(bounds.x, 0)])
    }
    
    func computeNormals() -> [float2] {
        var normals: [float2] = []
        vertices.count.loop {
            normals.append(getFace($0).normal)
        }
        return normals
    }
    
    func getFace(_ index: Int) -> Face {
        let next = index + 1 >= vertices.count ? 0 : index + 1
        return Face(vertices[index], vertices[next])
    }
    
    func getVertices() -> [float2] {
        return vertices
    }
    
    func getSupport(_ normal: float2) -> float2 {
        return vertices[findBestIndex(0 ..< vertices.count, -FLT_MAX, >) { dot(vertices[$0], normal) }!]
    }
}

class Radialform: Form {
    let divides = 40
    var vertices: [float2] = []
    var radius: Float
    
    init(_ radius: Float) {
        self.radius = radius
        vertices = computeVertices(radius).centered.reversed()
    }
    
    private func computeVertices(_ radius: Float) -> [float2] {
        var verts: [float2] = []
        
        verts.append(float2())
        
        for n in 1 ..< divides + 1 {
            let percent = Float(n - 1) / Float(divides)
            let angle = percent * Float(M_PI * 2)
            verts.append(radius * float2(cosf(angle), sinf(angle)))
        }
        
        return verts
    }
    
    func getVertices() -> [float2] {
        return vertices
    }
}
