//
//  PlayerShield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerShield: Shield {
    override func damage(_ amount: Float) {
        if upgrader.shieldpower.range.percent == 1 {
            if random(0, 1) <= 0.1 {
                return
            }
        }
        super.damage(amount)
    }
}
