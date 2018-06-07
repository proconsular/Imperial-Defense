//
//  Anvil.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Anvil {
    let display: Display
    let animator: Animator
    var counter: Float
    
    init(_ location: float2) {
        display = Display(Rect(location, float2(32) * 7), GLTexture("Anvil"))
        display.coordinates = SheetLayout(0, 6, 2).coordinates
        let texture = TextureAnimator(GLTexture("Anvil").id, SheetLayout(0, 6, 2))
        texture.append(SheetAnimator(0.05, [AnvilEvent([2])], SheetAnimation(0, 6, 6, 1)))
        texture.append(SheetAnimator(0.2, [], SheetAnimation(6, 4, 6, 1)))
        animator = Animator(TimedAnimationPlayer(texture))
        animator.set(1)
        counter = 0
    }
    
    func work() {
        counter = 3
        animator.set(0)
    }
    
    func render() {
        counter -= Time.delta
        if counter < 0 && animator.player.animation.frame == 0 {
            animator.set(1)
        }
        animator.update()
        animator.apply(display.material)
        display.refresh()
        display.render()
    }
}
