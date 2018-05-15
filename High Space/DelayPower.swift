//
//  DelayPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DelayPower: UnitPower {
    var cost: Float = 0
    unowned let controller: UnitController
    let amount: Float
    
    init(_ controller: UnitController, _ amount: Float) {
        self.controller = controller
        self.amount = amount
    }
    
    func isAvailable(_ power: Float) -> Bool {
        return true
    }
    
    func invoke() {
        controller.counter.increment = -amount
    }
    
    func update() {
        
    }
}
