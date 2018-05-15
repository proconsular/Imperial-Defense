//
//  Animator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/9/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Animator {
    var player: AnimationPlayer
    var lastFrame: Int
    
    init(_ player: AnimationPlayer) {
        self.player = player
        lastFrame = 0
    }
    
    func update() {
        player.update()
        let frame = player.animation.frame
        if let event = player.animation.event {
            if frame != lastFrame {
                event.activate()
            }
        }
        lastFrame = frame
    }
    
    func set(_ animation: Int) {
        player.animation.set(animation)
    }
    
    func apply(_ material: ClassicMaterial) {
        material.coordinates = player.animation.coordinates
    }
}
