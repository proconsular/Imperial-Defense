//
//  TimedAnimationPlayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class TimedAnimationPlayer: AnimationPlayer {
    var animation: Animation
    var timer: Timer
    
    init(_ animation: Animation) {
        self.animation = animation
        timer = Timer(animation.rate) {
            animation.animate()
        }
    }
    
    func update() {
        timer.rate = animation.rate
        timer.update(Time.delta)
    }
}
