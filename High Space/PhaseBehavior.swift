//
//  PhaseBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PhaseBehavior: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    unowned let battery: Battery
    
    init(_ soldier: Soldier, _ battery: Battery) {
        self.soldier = soldier
        self.battery = battery
    }
    
    func update() {
        if soldier.transform.location.y <= -Camera.size.y { return }
        
        let energy = battery.amount / 100
        if roll(energy) {
            generate(Int(energy * 3))
        }
        
        battery.amount -= 25 * Time.delta
        
        if battery.amount <= 0 {
            soldier.alive = false
        }
    }
    
    func generate(_ amount: Int) {
        for _ in 0 ..< amount {
            let en = Particle(soldier.transform.location + float2(random(-0.3.m, 0.3.m), random(-0.5.m, 0.5.m)), 5)
            en.color = float4(0.95, 0.85, 0.95, 1) * 0.75
            en.handle.material["color"] = float4(0.95, 0.85, 0.95, 1) * 0.75
            en.rate = 5
            Map.current.append(en)
        }
    }
}
