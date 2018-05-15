//
//  UnitBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class UnitBehavior: Behavior {
    var alive: Bool = true
    let power: UnitPower
    
    init(_ power: UnitPower) {
        self.power = power
        
    }
    
    func update() {
        power.update()
        if power.isAvailable(100) {
            power.invoke()
        }
    }
}
