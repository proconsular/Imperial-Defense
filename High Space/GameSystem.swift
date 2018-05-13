//
//  GameSystem.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GameSystem {
    static func start() {
        Graphics.method.clear()
        ParticleSystem.current.clear()
        BulletSystem.current.clear()
        GameplayController.current = GameplayController()
        Camera.current = Camera()
        Time.scale = 1
    }
    
    static func update() {
        ParticleSystem.current.update()
        BulletSystem.current.update()
        GameplayController.current.update()
    }
    
    static func render() {
        Graphics.render()
        ParticleSystem.current.render()
        BulletSystem.current.render()
    }
}
