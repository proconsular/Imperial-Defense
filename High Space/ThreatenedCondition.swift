//
//  ThreatenedCondition.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ThreatenedCondition: PowerCondition {
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func isPassed() -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(1.m, 4.m)))
        for actor in actors {
            if let bullet = actor as? Bullet {
                if bullet.casing.tag == "enemy" {
                    return true
                }
            }
        }
        return false
    }
}
