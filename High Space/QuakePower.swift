//
//  QuakePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/13/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class QuakePower: TimedUnitPower {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier, _ cost: Float, _ wait: Float) {
        self.soldier = soldier
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        soldier.behavior.base.append(TemporaryBehavior(ShakeBehavior(0.25.m), 1) {
            Camera.current.transform.location = float2(0, -Camera.size.y)
        })
        
        Audio.play("shake", 0.25)
        Map.current.append(Halo(soldier.transform.location, 2.m))
    }
    
}

class ShakeBehavior: Behavior {
    var alive: Bool = true
    
    let magnitude: Float
    var power: Float = 1
    var direction: Float = 1
    
    init(_ magnitude: Float) {
        self.magnitude = magnitude
    }
    
    func update() {
        power = clamp(power - Time.delta, min: 0, max: 1)
        Camera.current.transform.location.x = power * magnitude * direction
        direction = direction == 1 ? -1 : 1
    }
}
