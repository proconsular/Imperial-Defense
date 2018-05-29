//
//  BossMarchAnimator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/28/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossMarchAnimator: Animator {
    
    init(_ body: Body, _ rate: Float, _ speed: Float) {
        let animation = TextureAnimator(GLTexture("soldier_walk").id, SheetLayout(0, 12, 3))
        animation.append(SheetAnimator(rate * 1.25, [BossMarchEvent(body, speed * 1.25, [0, 6])], SheetAnimation(0, 12, 12, 1)))
        super.init(TimedAnimationPlayer(animation))
    }
    
}
