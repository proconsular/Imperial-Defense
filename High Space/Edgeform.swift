//
//  Edgeform.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
        return vertices[findBestIndex(0 ..< vertices.count, -Float.greatestFiniteMagnitude, >) { dot(vertices[$0], normal) }!]
    }
}
