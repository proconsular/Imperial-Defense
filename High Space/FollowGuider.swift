//
//  FollowGuider.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class FollowGuider: Guider {
    
    let body: Body
    let target: Transform
    let speed: Float
    
    init(_ body: Body, _ target: Transform, _ speed: Float) {
        self.body = body
        self.target = target
        self.speed = speed
    }
    
    func update() {
        let dl = target.global.location - body.location
        body.velocity += normalize(dl) * speed
    }
    
}
