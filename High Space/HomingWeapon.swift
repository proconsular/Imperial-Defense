//
//  HomingWeapon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/23/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HomingWeapon: Weapon {
    
    func fire(_ target: Entity) {
        if let firer = firer as? HomingFirer {
            firer.fire(transform.location + 0.75.m * direction + offset, target)
        }
    }
    
}
