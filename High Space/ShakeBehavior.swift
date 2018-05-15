//
//  ShakeBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShakeBehavior: Behavior {
    var alive: Bool = true
    
    let magnitude: Float
    var power: Float = 1
    var direction: Float = 1
    
    init(_ magnitude: Float) {
        self.magnitude = magnitude
    }
    
    func update() {
        power = clamp(power - Time.delta, min: 0, max: 1)
        Camera.current.transform.location.x = power * magnitude * direction
        direction = direction == 1 ? -1 : 1
    }
}
