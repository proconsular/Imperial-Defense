//
//  Firepower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FirePowerUpgrade: Upgrade {
    
    let maximum: Power
    
    init(_ maximum: Power) {
        self.maximum = maximum
        super.init("Gun", "Power")
    }
    
    func apply(_ power: inout Power) {
        power.limit += maximum.limit * range.percent
    }
    
    override func computeCost() -> Int {
        return 8
    }
    
}
