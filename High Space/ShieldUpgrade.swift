//
//  ShieldUpgrade.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ShieldUpgrade: Upgrade {
    
    let maximum: ShieldPower
    
    init(_ maximum: ShieldPower) {
        self.maximum = maximum
        super.init("Shield", "Defense")
    }
    
    func apply(_ shield: Shield) {
        shield.mods.append(ShieldPower(maximum.amount * range.percent, maximum.recharge * range.percent))
    }
    
    override func computeCost() -> Int {
        return 4
    }
    
}
