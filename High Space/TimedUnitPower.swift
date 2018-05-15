//
//  TimedUnitPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
