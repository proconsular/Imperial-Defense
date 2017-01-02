//
//  Rect.swift
//  Defender
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Rect: Shape<Edgeform> {
    private(set) var bounds: float2
    private var rect: FixedRect
    private var orientation: Float
    
    init(_ transform: Transform = Transform(), _ bounds: float2) {
        self.bounds = bounds
        orientation = 0
        rect = FixedRect(float2(), float2())
        super.init(transform, Edgeform(bounds))
        computeRect()
    }
    
    convenience init(_ location: float2, _ bounds: float2) {
        self.init(Transform(location), bounds)
    }
    
    override func getBounds() -> FixedRect {
        rect.location = transform.location
        if orientation != transform.orientation {
            orientation = transform.orientation
            computeRect()
        }
        return rect
    }
    
    private func computeRect() {
        var min = float2(FLT_MAX, -FLT_MAX), max = float2(-FLT_MAX, FLT_MAX)
        
        for n in 0 ..< form.vertices.count {
            let vertex = getTransformedVertex(n) - transform.location
            
            if vertex.x > max.x {
                max.x = vertex.x
            }
            if vertex.y < max.y {
                max.y = vertex.y
            }
            if vertex.x < min.x {
                min.x = vertex.x
            }
            if vertex.y > min.y {
                min.y = vertex.y
            }
        }
        
        rect = FixedRect(transform.location, float2(max.x - min.x, -max.y + min.y))
    }
    
    func setBounds(_ newBounds: float2) {
        self.bounds = newBounds
        form = Edgeform(newBounds)
        computeBoundingCircle()
        computeRect()
    }
    
}
