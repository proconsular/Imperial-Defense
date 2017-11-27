//
//  PlayerWalk.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerWalk: PlayerAnimation {
    unowned let body: Body
    unowned let animator: TextureAnimator
    var anim_timer: Float = 0
    
    init(_ body: Body, _ animator: TextureAnimator) {
        self.body = body
        self.animator = animator
    }
    
    func update() {
        if abs(body.velocity.x) >= 2 {
            anim_timer += Time.delta
            if anim_timer >= 0.05 {
                anim_timer = 0
                animator.animate()
                if animator.frame == 2 {
                    Audio.start("player-step", 3)
                }
            }
        }else{
            animator.current.animation.index = 0
        }
    }
}
