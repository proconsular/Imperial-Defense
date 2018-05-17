//
//  Enemies.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BaseMarchAnimator: Animator {
    
    init(_ body: Body, _ rate: Float, _ speed: Float) {
        let animation = TextureAnimator(GLTexture("soldier_walk").id, SheetLayout(0, 12, 3))
        animation.append(SheetAnimator(rate * 1.25, [MarchEvent(body, speed * 1.25, [0, 6])], SheetAnimation(0, 12, 12, 1)))
        animation.append(SheetAnimator(rate * 1.5, [MarchEvent(body, speed * 3, [12, 16])], SheetAnimation(12, 8, 12, 1)))
        super.init(TimedAnimationPlayer(animation))
        //animation.current.animation.index = randomInt(0, 12)
    }
    
}
















