//
//  DeathEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class DeathEvent: PlayerEvent {
    unowned let player: Player
    
    init(_ player: Player) {
        self.player = player
    }
    
    func isActive() -> Bool {
        return player.health.percent <= 0
    }
    
    func trigger() {
        Audio.stop("Battle")
        Audio.play("player_died", 0.5)
        player.animation = PlayerDeath(player)
        player.animator.set(1)
        player.dead = true
        Game.instance.level.simulation.speed = 0.05
        Time.scale = 0.05
    }
}
