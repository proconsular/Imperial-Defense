//
//  File.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Energy: Particle {
    
    override func update() {
        super.update()
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(size * 4)))
        for actor in actors {
            if let bullet = actor as? Bullet {
                if bullet.casing.tag == "enemy" {
                    let dl = bullet.transform.location - transform.location
                    if dl.length <= size * 2 {
                        bullet.alive = false
                        alive = false
                        Audio.play("boss_deflect", 1)
                    }
                }
            }
        }
    }
    
}
