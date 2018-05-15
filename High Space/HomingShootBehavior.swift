//
//  HomingShootBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class HomingShootBehavior: ShootBehavior {
    var target: Entity
    
    init(_ weapon: Weapon, _ soldier: Soldier, _ target: Entity) {
        self.target = target
        super.init(weapon, soldier)
    }
    
    override func fire() {
        if weapon.canFire && target.alive {
            if let weapon = weapon as? HomingWeapon {
                weapon.fire(target)
            }
            let s = Audio("enemy-shoot-magic")
            s.volume = sound_volume
            s.start()
        }
    }
}
