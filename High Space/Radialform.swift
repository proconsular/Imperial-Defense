//
//  Radialform.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Radialform: Form {
    static let divides = 40
    var vertices: [float2] = []
    var radius: Float
    
    init(_ radius: Float) {
        self.radius = radius
        vertices = computeVertices(radius).centered.reversed()
    }
    
    private func computeVertices(_ radius: Float) -> [float2] {
        var verts: [float2] = []
        
        verts.append(float2())
        
        for n in 1 ..< Radialform.divides + 1 {
            let percent = Float(n - 1) / Float(Radialform.divides)
            let angle = percent * Float(Float.pi * 2)
            verts.append(radius * float2(cosf(angle), sinf(angle)))
        }
        
        return verts
    }
    
    func getVertices() -> [float2] {
        return vertices
    }
}
