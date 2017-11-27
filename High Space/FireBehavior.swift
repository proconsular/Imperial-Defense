//
//  FireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FireBehavior: Behavior {
    
    var alive: Bool = true
    unowned var soldier: Soldier
    var cooldown: Float
    var rate: Float
    
    init(_ soldier: Soldier, _ rate: Float) {
        self.soldier = soldier
        cooldown = rate
        self.rate = rate
    }
    
    func update() {
        cooldown -= Time.delta
        if cooldown <= 0 {
            if let gun = soldier.weapon {
                gun.fire()
                let s = Audio("shoot3")
                s.volume = sound_volume
                s.start()
                cooldown = rate
            }
        }
    }
}
