//
//  FastLaserBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class FastLaserBlastBehavior: LaserBlastBehavior {
    let start: Float
    
    init(_ start: Float, _ speed: Float, _ length: Float, _ laser: Laser, _ shield: ParticleShield) {
        self.start = start
        super.init(speed, length, laser, shield)
        angle = start
    }
    
    override func activate() {
        angle = start
        laser.direction = vectorize(angle)
        super.activate()
    }
}
