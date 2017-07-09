//
//  Animator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/9/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Event {
    var frames: [Int] { get }
    func activate()
}

class MarchEvent: Event {
    
    var body: Body
    var amount: Float
    var frames: [Int]
    var pitch: Float
    var foot: Int = 0
    
    init(_ body: Body, _ amount: Float, _ frames: [Int]) {
        self.body = body
        self.amount = amount
        self.frames = frames
        pitch = random(0.9, 1) + amount / 40.m
    }
    
    func activate() {
        let dl = (Player.player.body.location - body.location).length
        body.velocity.y += amount * (0.016666)
        let audio = Audio(foot == 0 ? "march" : "march-2")
        if !audio.playing {
            audio.volume = sound_volume * 2 * clamp(0.05 + 1 + body.location.y / Camera.size.y, min: 0, max: 1) * clamp(1 - dl / 50.m, min: 0, max: 1)
            audio.pitch = pitch
            audio.start()
        }
        foot = foot == 0 ? 1 : 0
    }
    
}

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
