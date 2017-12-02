//
//  PhantomController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/29/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PhantomController: Behavior {
    var alive = true
    
    unowned let soldier: Soldier
    
    var power: Float = 1
    
    var health: Float = 100
    
    var blasts: [EnergyBlast] = []
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func update() {
        
        power += Time.delta
        
        if soldier.transform.location.y <= -Camera.size.y + 0.5.m { return }
        
        health += -20 * Time.delta
        
        if roll(energy) && roll(0.5) {
            generate(Int(energy * 5))
        }
        
        if ((roll(1 - energy) && roll(0.1)) || roll(0.005)) {
            eat()
        }
        
        if health <= 0 {
            soldier.damage(soldier.health.stamina.points.amount)
        }
        
        if energy > 1 && roll(0.25) && power >= 6 && ActorUtility.hasLineOfSight(soldier) {
            let blast = EnergyBlast(soldier.transform.location, health - 50)
            blast.velocity = float2(0, random(0.25.m, 2.m))
            blasts.append(blast)
            health = 100
            power -= 6
        }
        
        blasts.forEach{ $0.update() }
        blasts = blasts.filter{ $0.alive }
    }
    
    var energy: Float {
        return health / 100
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
    
    func eat() {
        var target: Soldier?
        let actors = Map.current.getActors(rect: FixedRect(soldier.transform.location, float2(4.m)))
        for actor in actors {
            if let soldier = actor as? Soldier, !soldier.immune, soldier !== self.soldier {
                target = soldier
                break
            }
        }
        if let unit = target {
            var total: Float = 0
            if let shield = unit.health.shield {
                total += shield.points.amount
            }
            total += unit.health.stamina.points.amount
            unit.damage(total)
            health += total
        }
    }
    
    func roll(_ percent: Float) -> Bool {
        return 1 - percent <= random(0, 1)
    }
    
}
