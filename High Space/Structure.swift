//
//  Basic.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Structure: Entity {
    let rect: Rect
    
    init(_ location: float2, _ bounds: float2) {
        rect = Rect(location, bounds)
        super.init(rect, rect, Substance.Solid)
        material.color = float4(0.11, 0.11, 0.12, 1)
        body.mask = Int.max
        body.object = self
    }
}
