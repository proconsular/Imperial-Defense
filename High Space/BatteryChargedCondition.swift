//
//  Conditions.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/4/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BatteryChargedCondition: PowerCondition {
    unowned let battery: Battery
    let amount: Float
    
    init(_ battery: Battery, _ amount: Float) {
        self.battery = battery
        self.amount = amount
    }
    
    func isPassed() -> Bool {
        return battery.amount >= amount
    }
}





















