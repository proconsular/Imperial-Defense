//
//  ShootBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShootBehavior: Behavior {
    var alive: Bool = true
    unowned var weapon: Weapon
    unowned var soldier: Soldier
    var sound: String
    
    var charge_timer: Float = 0
    
    init(_ weapon: Weapon, _ soldier: Soldier, _ sound: String = "enemy-shoot") {
        self.weapon = weapon
        self.soldier = soldier
        self.sound = sound
    }
    
    func update() {
        if shouldFire() && canSee() {
            fire()
        }
    }
    
    func shouldFire() -> Bool {
        var dl = float2()
        if let player = Player.player {
            dl = player.body.location - soldier.body.location
        }
        let d = min(dl.x / 1.m, 1)
        let roll = (1 - d) * 0.2
        return random(0, 1) < (0.05 + roll)
    }
    
    func canSee() -> Bool {
        return ActorUtility.hasLineOfSight(soldier)
    }
    
    func fire() {
        if weapon.canFire {
            weapon.fire()
            if sound == "enemy-shoot-heavy" {
                Audio.play(sound, 0.5)
            }else{
                Audio.play(sound, 0.125)
            }
            
        }
    }
}
