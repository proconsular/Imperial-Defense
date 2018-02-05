//
//  EnergyBlast.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/29/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyBlast {
    var alive = true
    
    let transform: Transform
    
    var velocity: float2
    var health: Float
    
    var engaged = false
    var direction: Float = 1
    
    var hum: Counter
    
    init(_ location: float2, _ health: Float) {
        transform = Transform(location)
        self.health = health
        velocity = float2()
        hum = Counter(0.05)
    }
    
    func update() {
        health += -15 * Time.delta
        
        transform.location += velocity * Time.delta
        velocity *= 0.99
        
        if roll(health / 50) && roll(0.75) {
            generate(Int((health / 50) * 5))
        }
        
        if let player = Player.player {
            let dl = player.transform.location - transform.location
            velocity += normalize(dl) * 1.m
            
            if dl.length <= 15.m && dl.x != 0 {
                player.body.velocity.x += clamp((25.m / -dl.x) * 10, min: -4.m, max: 4.m) * (health / 25)
            }
            
            if dl.length <= 2.m {
                engaged = true
                direction = randomInt(0, 1) == 0 ? 1 : -1
            }
        }
        
        if engaged {
            let dl = float2(direction == 1 ? Camera.size.x : 0, -Camera.size.y * 0.1) - transform.location
            velocity.x += dl.x / 10
            velocity.y += dl.y / 3
            velocity.y *= 0.9
            if dl.length <= 0.5.m {
                health = 0
            }
        }
        
        if health <= 0 {
            alive = false
        }
        
        hum.update(Time.delta) {
            Audio.play("energy-move", 0.75)
        }
    }
    
    func generate(_ amount: Int) {
        for _ in 0 ..< amount {
            let size = 0.5.m
            let dl = float2(random(-1, 1), random(-1, 1))
            let en = Particle(transform.location + normalize(dl) * random(0, size), 5)
            en.color = float4(0.95, 0.85, 0.95, 1) * 0.75
            en.handle.material["color"] = float4(0.95, 0.85, 0.95, 1) * 0.75
            en.rate = 3
            Map.current.append(en)
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}
