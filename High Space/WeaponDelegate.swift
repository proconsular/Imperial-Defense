//
//  WeaponDelegate.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol WeaponDelegate {
    func update()
}

class PlayerWeaponSound: WeaponDelegate {
    unowned let player: Player
    var percent: Float
    
    init(_ player: Player) {
        self.player = player
        percent = 0
    }
    
    func update() {
        if !player.firing {
            if percent < 1 && player.weapon.percent >= 1 {
                Audio.start("power_full")
            }
            percent = player.weapon.percent
        }
    }
}
