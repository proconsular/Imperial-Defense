//
//  BuyEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BuyEffect {
    let display: Display
    let animator: Animator
    var active: Bool = false
    
    let texture_animator: TextureAnimator
    
    init() {
        display = Display(Rect(float2(), float2(128 * 3)), GLTexture("Upgrade_Effects"))
        texture_animator = TextureAnimator(GLTexture("Upgrade_Effects").id, SheetLayout(0, 5, 2))
        texture_animator.append(SheetAnimator(0.025, [], SheetAnimation(0, 5, 5, 2)))
        animator = Animator(TimedAnimationPlayer(texture_animator))
    }
    
    func update() {
        animator.update()
        animator.apply(display.material)
    }
    
    func activate(_ location: float2) {
        display.transform.location = location + float2(0, -GameScreen.size.y)
        texture_animator.current.animation.index = 0
        active = true
    }
    
    func render() {
        if active {
            display.refresh()
            display.render()
        }
        if texture_animator.frame >= 4 {
            active = false
        }
    }
}
