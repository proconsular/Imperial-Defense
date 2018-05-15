//
//  Ghost.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 9/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GhostEffect: Entity {
    
    var color: float4
    let rate: Float
    var opacity: Float
    
    init(_ entity: Entity, _ rate: Float) {
        self.rate = rate
        opacity = 1
        
        color = entity.handle.material["color"] as! float4
        color *= 0.9
        color.w = 1
        
        let rect = Rect(entity.transform.location, entity.handle.hull.getBounds().bounds)
        super.init(rect, rect, Substance.getStandard(1))
        
        material["texture"] = entity.handle.material["texture"]
        material["color"] = entity.handle.material["color"]
        material.coordinates = (entity.handle.material as! ClassicMaterial).coordinates
        
        material["order"] = (entity.handle.material["order"] as! Int) - 1
        
        transform.orientation = entity.transform.orientation
        
        body.noncolliding = true
        body.mask = 0b0
    }
    
    override func update() {
        opacity -= rate * Time.delta
        if opacity <= 0 {
            alive = false
        }
        material["color"] = color * opacity
    }
    
}










