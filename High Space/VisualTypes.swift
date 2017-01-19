//
//  VisualTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct TextureLayout {
    var coordinates: [float2]
    
    init(_ coordinates: [float2]) {
        self.coordinates = coordinates
    }
    
    init(_ hull: Hull) {
        if hull is Rect {
            self.coordinates = [float2(0, 0), float2(0, 1), float2(1, 1), float2(1, 0)]
        }else{
            self.coordinates = TextureLayout.generateCoordinates(hull)
        }
    }
    
    mutating func flip(vector: float2) {
        for n in 0 ..< coordinates.count {
            coordinates[n].x *= vector.x
        }
    }
    
    private static func generateCoordinates(_ hull: Hull) -> [float2] {
        let vertices = hull.getVertices().dropFirst()
        
        var coordinates: [float2] = []
        
        coordinates.append(float2(0.5))
        
        for vertex in vertices {
            let angle = atan2f(vertex.y, vertex.x)
            coordinates.append(float2(cosf(angle) / 2 + 0.5, sinf(angle) / 2 + 0.5))
        }
        
        return coordinates
    }
}

struct VisualInfo {
    var texture: UInt32
    var color: float4
    
    init(_ texture: UInt32, _ color: float4 = float4(1)) {
        self.texture = texture
        self.color = color
    }
}
