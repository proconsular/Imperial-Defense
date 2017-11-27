//
//  HomingBullet.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HomingBullet: Bullet {
    
    var target: Entity
    
    init(_ location: float2, _ target: Entity, _ impact: Impact, _ casing: Casing) {
        self.target = target
        super.init(location, float2(), impact, casing)
    }
    
    override func update() {
        let dl = target.transform.location - transform.location
        body.orientation = atan2(dl.y, dl.x)
        if dl.length > 0 {
            body.velocity = impact.speed * normalize(dl)
        }
    }
    
}
