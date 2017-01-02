//
//  BoundingShapes.swift
//  Defender
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct BoundingCircle {
    var location: float2
    var radius: Float
    
    init(_ location: float2, _ radius: Float) {
        self.location = location
        self.radius = radius
    }
    
    func intersects(_ other: BoundingCircle) -> Bool {
        let dl = (location - other.location).length
        let dr = radius + other.radius
        return dl <= dr
    }
    
    func contains(_ location: float2) -> Bool {
        let dl = (self.location - location).length
        return dl <= radius
    }
}
