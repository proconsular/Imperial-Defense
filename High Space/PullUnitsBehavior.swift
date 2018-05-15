//
//  PullUnitsBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PullUnitsBehavior: Behavior {
    var alive: Bool = true
    
    unowned let transform: Transform
    let radius: Float
    
    init(_ transform: Transform, _ radius: Float) {
        self.transform = transform
        self.radius = radius
    }
    
    func update() {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                let dl = transform.location - soldier.transform.location
                if length(dl) <= radius && length(dl) >= 1.m {
                    soldier.transform.location += dl / 1.m
                }
            }
        }
    }
}
