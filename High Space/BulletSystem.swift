//
//  BulletSystem.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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

