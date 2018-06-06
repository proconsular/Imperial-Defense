//
//  PlayerDeath.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerDeath: PlayerAnimation {
    unowned let player: Player
    var death_timer: Float = 0
    var anim_timer: Float = 0
    
    init(_ player: Player) {
        self.player = player
    }
    
    func update() {
        updateDeath()
        colorize()
        animate()
    }
    
    func updateDeath() {
        death_timer += Time.normal
        if death_timer >= 5 {
            player.alive = false
            Game.instance.level.simulation.speed = 1
            Time.scale = 1
            player.terminator?.terminate()
        }
    }
    
    func colorize() {
        let c = Float(Int(death_timer * 400) % 2)
        player.material["color"] = float4(1, c, c, 1)
    }
    
    func animate() {
        anim_timer += Time.normal
        if anim_timer >= 1 && player.animator.frame < 11 {
            anim_timer = 0
            Audio.play("player_fall", 0.5)
            player.animator.animate()
        }
    }
    
    deinit {
        Time.scale = 1
    }
}
