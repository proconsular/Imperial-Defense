//
//  Rubble.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Rubble: Entity {
    
    init(_ location: float2) {
        let rect = Rect(location, float2(32 * 2))
        super.init(rect, rect, Substance.getStandard(1))
        material.order = 1
        body.noncolliding = true
        body.mask = 0b0
        
        material["texture"] = GLTexture("Rubble").id
        material.coordinates = SheetLayout(randomInt(1, 2), 3, 1).coordinates
    }
    
}
