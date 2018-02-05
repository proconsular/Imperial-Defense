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
    
    var hum: Counter
    
    init(_ soldier: Soldier, _ battery: Battery) {
        self.soldier = soldier
        self.battery = battery
        hum = Counter(0.25)
    }
    
    func update() {
        if soldier.transform.location.y <= -Camera.size.y { return }
        
        let energy = battery.amount / 100
        if roll(energy) {
            generate(Int(energy * 3))
        }
        
        var rate: Float = 25
        
        let count = getNearbySoldiersCount(2.5.m)
        if count <= 0 {
            rate = 40
        }else{
            rate -= 10 * clamp(Float(count) / 10, min: 0, max: 1)
        }
        
        battery.amount -= rate * Time.delta
        
        if battery.amount <= 0 {
            soldier.alive = false
        }
        
        hum.update(Time.delta) {
            if roll(energy) {
                Audio.play("phantom-power", 0.1)
            }
        }
    }
    
    func getNearbySoldiersCount(_ radius: Float) -> Int {
        var count = 0
        let actors = Map.current.getActors(rect: FixedRect(soldier.transform.location, float2(2.5.m)))
        for actor in actors {
            let dl = soldier.transform.location - actor.transform.location
            if dl.length <= radius {
                count += 1
            }
        }
        return count
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
