//
//  Cooldown.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/2/17.
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

class TimedUnitPower: UnitPower {
    let cost: Float
    let wait: Float
    var counter: Float
    var conditions: [PowerCondition]
    
    init(_ cost: Float, _ wait: Float) {
        self.cost = cost
        self.wait = wait
        counter = wait
        conditions = []
    }
    
    func isAvailable(_ power: Float) -> Bool {
        return counter >= wait && cost <= power && isPassed()
    }
    
    private func isPassed() -> Bool {
        for condition in conditions {
            if !condition.isPassed() {
                return false
            }
        }
        return true
    }
    
    func invoke() {
        counter = 0
    }
    
    func update() {
        counter += Time.delta
    }
    
}

protocol PowerCondition {
    func isPassed() -> Bool
}





















