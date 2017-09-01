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
    
    init() {
        renderer = PointRenderer()
    }
    
    func append(_ graphic: GraphicsInfo) {
        renderer.append(graphic)
        renderer.compile()
    }
    
    func clear() {
        renderer = PointRenderer()
    }
    
    func update() {
        renderer.update()
    }
    
    func render() {
        renderer.render()
    }
    
}
