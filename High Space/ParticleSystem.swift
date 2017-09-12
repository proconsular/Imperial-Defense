//
//  ParticleSystem.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/30/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleSystem {
    static let current = ParticleSystem()
    
    var renderer: PointRenderer
    var updated: Bool = false
    
    init() {
        renderer = PointRenderer()
    }
    
    func append(_ graphic: GraphicsInfo) {
        renderer.append(graphic)
        updated = true
    }
    
    func clear() {
        renderer = PointRenderer()
    }
    
    func update() {
        if updated {
            renderer.compile()
            updated = false
        }
        renderer.update()
    }
    
    func render() {
        renderer.render()
    }
}

class BulletSystem {
    static let current = BulletSystem()
    
    var renderer: BaseRenderer
    var updated: Bool = false
    
    init() {
        renderer = BaseRenderer()
    }
    
    func append(_ graphic: GraphicsInfo) {
        renderer.append(graphic)
        updated = true
    }
    
    func clear() {
        renderer = BaseRenderer()
    }
    
    func update() {
        if updated {
            renderer.compile()
            updated = false
        }        
        renderer.update()
    }
    
    func render() {
        renderer.render()
    }
}
























