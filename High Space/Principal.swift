//
//  Principal.swift
//  Comm
//
//  Created by Chris Luttio on 8/28/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Principal: Bot, Interface {
    
    static let jumpHeight: Float = 5.4.m
    static let jumpLeap: Float = 0.7.m
    static let speedLimit: Float = 4.m
    static let acceleration: Float = 5.4.m
    
    var onFloor = false
    var onPlatforms = false
    
    var jump = (count: 0, limit: 1)
    
    init(_ location: float2) {
        super.init(location, float2(100, 210), float2(150))
        
        body.substance.mass = Mass(0.3, 0)
        
        var counter = 0
        
        animations[0].action = { [unowned self] in
            if counter % 23 == 0 {
                if self.onPlatforms {
                    playSound("platform_walk")
                }else{
                    playSound("footsteps")
                }
            }
            counter += 1
        }
    }
    
    static func getJumpDistance(length: Float) -> Float {
        let square = sqrtf(2 * gravity.y * length + sqr(jumpHeight))
        let t = (jumpHeight + square) / gravity.y
        return (speedLimit + jumpLeap) * t
    }
    
    override func getRelativeFloor (body: Body, _ collision: Collision) {
        guard collision.normal.y != 0 else { return }
        onObject = true
       
        if let tag = body.tag {
            useTag(tag)
            var attentuation = (1 - 500 / body.velocity.y) / 2
            attentuation = clamp(attentuation, min: 0, max: 1)
            let hitObject = onObject && !wasOnObject
            if hitObject {
                switch tag {
                case "Platform":
                    playSound("platform_hit", attentuation)
                case "Floor":
                    playSound("ground_hit", attentuation)
                default: break
                }
            }
        }
    }
    
    private func useTag (tag: String) {
        (tag == "Floor").isTrue(onFloor = true)
        (tag == "Platform").isTrue(onPlatforms = true)
    }
    
    override func generateAnimationInfo() -> [TextureReaderInfo] {
        return [
            TextureReaderInfo ("Running", float2 (380), 5, 47, 0.01),
            TextureReaderInfo ("Jumping", float2 (380), 5, 18, 0.02, false),
        ]
    }
    
    override func determinePose() -> Pose {
        var currentPose: Pose = .Running
        if !onObject { currentPose = .Jumping }
        return currentPose
    }
    
    override func update(processedTime: Float) {
        computeRelativeLocation()
        managePoses(processedTime)
        super.update(processedTime)
    }
    
    private func computeRelativeLocation () {
        if !onObject { onFloor = false }
        (onFloor && onPlatforms).isTrue(onPlatforms = false)
    }
    
    private func managePoses (processedTime: Float) {
        if onObject {
            getAnimation(.Jumping).reset()
            jump.count = 0
        }
    }
    
    override func display() {
        setPose()
        Being.display(visual, body.location, body.orientation, computeOffset())
    }
    
    private func computeOffset () -> float2 {
        var offset = float2()
        if let pose = currentPose where pose == .Jumping {
            offset = float2(-30, -10)
        }
        return offset
    }
    
    func use (command: Command) {
        if case .Vector(let force) = command {
            move(force.x)
        } else if case .Pressed = command {
            jumpup()
        }
    }
    
    private func move(amount: Float) {
        let boost = 0.7.m
        body.velocity.x += amount / 30
        if abs(body.velocity.x) >= Principal.speedLimit + boost {
            body.velocity.x = (Principal.speedLimit + boost) * (body.velocity.x.normalized ?? 0)
        }
    }
    
    private func jumpup() {
        var force = -(Principal.jumpHeight)
        if jump.count > 0 { force /= 3 }
        if (jump.count >= jump.limit) || abs(body.velocity.y) >= 600 { return }
        jump.count += 1
        
        if onPlatforms {
            body.velocity.x += Principal.jumpLeap
        }
        
        body.velocity.y = force
        getAnimation(.Jumping).reset()
        if onPlatforms {
            playSound("platform_jump")
        }else{
            playSound("jump")
        }
    }
    
}











