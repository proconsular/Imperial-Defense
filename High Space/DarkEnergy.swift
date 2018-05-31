//
//  DarkEnergy.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DarkEnergy: Particle {
    override func update() {
        super.update()
        if let player = Player.player {
            let dl = player.transform.location - transform.global.location
            if dl.length <= size * 3 && opacity >= 0.1 {
                player.damage(10 * (fabsf(player.body.velocity.x) / 1.m))
            }
        }
    }
}
