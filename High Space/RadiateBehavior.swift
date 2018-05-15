//
//  RadiateBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RadiateBehavior: Behavior {
    var alive = true
    
    unowned let transform: Transform
    var timer: Float = 0
    
    var energy: [FireEnergy]
    
    var offset: Float = 0
    
    var hum: Counter
    
    init(_ transform: Transform) {
        self.transform = transform
        energy = []
        hum = Counter(0.1)
    }
    
    func update() {
        timer += Time.delta
        if timer >= 0.01 {
            timer = 0
            for _ in 0 ..< 3 {
                generate()
            }
        }
        offset += 0.5 * Time.delta
        energy = energy.filter{ $0.alive }
        for fire in energy {
            if let player = Player.player {
                let dl = player.transform.location - fire.transform.location
                let dtl = player.transform.location - transform.location
                fire.body.velocity += (250000.m / (dl.length * dl.length)) * normalize(dl)
                let percent = (1 - dl.length / dtl.length)
                let cycle = fmodf(percent + offset, 1)
                fire.color = float4(1, 0.5, 0.5, 1) * (cycle) + float4(1) * (1 - cycle)
                if dl.length <= 0.5.m {
                    fire.alive = false
                }
            }
        }
        
        hum.update(Time.delta) {
            Audio.play("energy-pour", 0.1)
        }
    }
    
    func generate() {
        let loc = float2(random(-0.25.m, 0.25.m), random(-0.5.m, 0.5.m))
        let fire = FireEnergy(transform.location + loc, 4)
        fire.color = float4(1, 0.5, 0.5, 1)
        fire.rate = 0.5
        fire.body.velocity += normalize(float2(random(-1, 1), random(-1, 1))) * 4.m
        fire.drag = float2(0.9)
        fire.effect = nil
        energy.append(fire)
        Map.current.append(fire)
    }
}
