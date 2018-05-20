//
//  PlayerInterface.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerInterface: Interface {
    weak var player: Player?
    var speed: Float
    var acceleration: Float
    var canFire = true
    var frozen = false
    
    init(_ player: Player, _ speed: Float, _ acceleration: Float) {
        self.player = player
        self.speed = speed
        self.acceleration = acceleration
    }
    
    func use(_ command: Command) {
        if let player = player {
            if player.dead { return }
            if frozen { return }
            if command.id == 0 {
                let force = command.vector! / 2000
                if abs(player.body.velocity.x) < speed {
                    player.body.velocity.x += force.x * acceleration
                }
            }else if command.id == 1 && canFire {
                if player.weapon.canFire {
                    let shoot = Audio("player-shoot")
                    shoot.pitch = player.weapon.isHighPower ? 0.6 : 1
                    shoot.volume = 0.1
                    shoot.start()
                    player.weapon.fire()
                }
                player.firing = true
            }
        }
    }
    
    func freeze() {
        frozen = true
    }
    
    func unfreeze() {
        frozen = false
    }
    
}
