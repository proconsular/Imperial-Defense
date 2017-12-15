//
//  ConsumePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ConsumePower: TimedUnitPower {
    unowned let soldier: Soldier
    unowned let battery: Battery
    
    init(_ soldier: Soldier, _ battery: Battery, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        self.battery = battery
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        var target: Soldier? = nil
        let actors = Map.current.getActors(rect: FixedRect(soldier.transform.location, float2(3.m)))
        for actor in actors {
            if let tg = actor as? Soldier, soldier !== tg {
                target = tg
                break
            }
        }
        
        if let t = target {
            soldier.behavior.base.append(TemporaryBehavior(ConsumeBehavior(soldier, t), 0.5) { [unowned self, weak t] in
                if let t = t {
                    var total: Float = 0
                    if let shield = t.health.shield {
                        total += shield.points.amount
                    }
                    total += t.health.stamina.points.amount
                    t.damage(total)
                    self.battery.amount += total * 2
                }
            })
        }
    }
    
}

class ConsumeBehavior: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    let drain: DrainEffect
    
    init(_ soldier: Soldier, _ target: Soldier) {
        self.soldier = soldier
        drain = DrainEffect(soldier)
        drain.target = target
    }
    
    func update() {
        drain.update()
    }
}
