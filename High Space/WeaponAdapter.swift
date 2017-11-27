//
//  WeaponAdapter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/23/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerWeaponDisplayAdapter: StatusItem {
    
    weak var weapon: PlayerWeapon?
    var warnings: [PowerWarning]
    
    init(_ weapon: PlayerWeapon) {
        self.weapon = weapon
        warnings = []
    }
    
    var percent: Float {
        return weapon?.percent ?? 0
    }
    
    var color: float4 {
        var c = weapon?.color ?? float4(0)
        warnings.forEach{ c = $0.apply(c) }
        return c
    }
    
    func update() {
        warnings.forEach{ $0.update(percent) }
    }
    
}
