//
//  ChargeBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CooldownBehavior: TriggeredBehavior {
    var alive = true
    let limit: Float
    var cooldown: Float
    
    init(_ limit: Float) {
        self.limit = limit
        cooldown = 0
    }
    
    var available: Bool {
        return cooldown >= limit
    }
    
    func activate() {
        cooldown = 0
    }
    
    func update() {
        cooldown += Time.delta
    }
    
    func trigger() {
        
    }
}

class RushBehavior: CooldownBehavior {
    unowned let transform: Transform
    var radius: Float
    
    init(_ transform: Transform, _ radius: Float, _ limit: Float) {
        self.transform = transform
        self.radius = radius
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        BehaviorQueue.instance.submit(BehaviorRequest("rush", self))
    }
    
    override func trigger() {
        Map.current.apply(FixedRect(transform.location, float2(radius))) {
            if let soldier = $0 as? Soldier {
                soldier.sprint()
            }
        }
        Explosion.create(transform.location, radius, float4(1, 0, 0, 1))
        Audio.start("enemy-rush")
    }
}

class TemporalBehavior {
    unowned let transform: Transform
    var counter, rate: Float
    
    init(_ transform: Transform, _ rate: Float) {
        self.transform = transform
        self.rate = rate
        counter = 0
    }
    
    func update() {
        if transform.location.y >= -Camera.size.y {
            counter += Time.delta
            if counter >= rate {
                counter = 0
                activate()
            }
        }
    }
    
    func activate() {}
}
















