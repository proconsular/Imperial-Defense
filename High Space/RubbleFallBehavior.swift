//
//  RubbleFallBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RubbleFallBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer: Float
    var frequency: Float
    
    init() {
        timer = 0
        frequency = 0
    }
    
    func activate() {
        active = true
        timer = 5
    }
    
    func update() {
        timer -= Time.delta
        if timer <= 0 {
            active = false
        }
        
        frequency += Time.delta
        if frequency >= 0.1 {
            frequency = 0
            var location = float2(random(2.m, Camera.size.x - 2.m), random(0, -Camera.size.y + 0.5.m))
            if randomInt(0, 10) < 6 {
                location.y = random(0, -4.m)
                if randomInt(0, 3) < 1 {
                    location.x = Player.player.transform.location.x
                }
            }
            Map.current.append(FallingRubble(location, normalize(float2(0.25, 1))))
            Audio.play("rubble_fall")
        }
    }
}
