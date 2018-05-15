//
//  NullPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class NullPower: UnitPower {
    var cost: Float = 0
    
    func isAvailable(_ power: Float) -> Bool {
        return true
    }
    
    func invoke() {}
    func update() {}
}
