//
//  Animator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/9/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Mover {
    func move()
}

class Marcher: Mover {
    
    var body: Body
    var amount: Float
    
    init(_ body: Body, _ amount: Float) {
        self.body = body
        self.amount = amount
    }
    
    func move() {
        body.location.y += amount
        let audio = Audio("march1")
        if !audio.playing {
            audio.volume = sound_volume * 0.5
            audio.start()
        }
    }
    
}

class Animator {
    
    var player: AnimationPlayer
    var mover: Mover
    var frames: [Int]
    var lastFrame: Int
    
    init(_ player: AnimationPlayer, _ mover: Mover, _ frames: [Int]) {
        self.player = player
        self.mover = mover
        self.frames = frames
        lastFrame = 0
    }
    
    func update() {
        player.update()
        let frame = player.animation.frame
        if active(player.animation.frame) && frame != lastFrame {
            mover.move()
            lastFrame = frame
        }
    }
    
    func active(_ frame: Int) -> Bool {
        for i in frames {
            if i == frame {
                return true
            }
        }
        return false
    }
    
    func apply(_ display: Display) {
        display.coordinates = player.animation.coordinates
    }
    
}

protocol AnimationPlayer {
    var animation: Animation { get }
    func update()
}

class TimedAnimationPlayer: AnimationPlayer {
    var animation: Animation
    var timer: Timer
    
    init(_ rate: Float, _ animation: Animation) {
        self.animation = animation
        timer = Timer(rate) {
            animation.animate()
        }
    }
    
    func update() {
        timer.update(Time.delta)
    }
    
}
