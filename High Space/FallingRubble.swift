//
//  FallingRubble.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class FallingRubble: Rubble {
    
    let target: float2
    let direction: float2
    
    init(_ location: float2, _ direction: float2) {
        target = location
        self.direction = direction
        let start = location + -direction * Camera.size.x
        super.init(start)
        bound = false
    }
    
    override func update() {
        body.velocity += direction * 20.m * Time.delta
        body.velocity *= 0.98
        
        let dt = (target - transform.location)
        if dt.length <= 0.5.m {
            alive = false
            Map.current.append(Explosion(target, 1.m))
            Audio.play("rubble_hit", 0.5)
        }
        
        let dl = Player.player.transform.location - transform.location
        if dl.length <= 0.5.m {
            Player.player.damage(100)
            alive = false
        }
    }
    
}
