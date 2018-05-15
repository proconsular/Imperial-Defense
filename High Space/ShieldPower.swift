//
//  ShieldPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct ShieldPower {
    var amount: Float
    var recharge: Float
    
    init(_ amount: Float, _ recharge: Float) {
        self.amount = amount
        self.recharge = recharge
    }
}
