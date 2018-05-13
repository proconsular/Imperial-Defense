//
//  Cell.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Cell {
    let size: Float
    let placement: Placement
    let location: float2
    let mask: FixedRect
    var elements: [Entity]
    
    init(_ placement: Placement, _ size: Float) {
        self.size = size
        self.placement = placement
        elements = []
        location = float2(Float(placement.location.x), -Float(placement.location.y)) * size
        mask = FixedRect(location + float2(size, -size) / 2, float2(size))
    }
    
    func append(_ element: Entity) {
        elements.append(element)
    }
    
    func contains(_ placed: Placed<Entity>) -> Bool {
        return mask.intersects(placed.element.body.shape.getBounds())
    }
}
