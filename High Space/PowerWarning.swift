//
//  PowerWarning.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class WeaponLowPowerWarning: ShieldLowPowerWarning {
    
    override func notify() {
        play("weapon_lowpower")
    }
    
}
