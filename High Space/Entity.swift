//
//  Entity.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Entity: Actor, Hittable {
    unowned let transform: Transform
    
    let handle: GraphicsInfo
    var material: ClassicMaterial
    let body: Body
    
    var onObject = false
    var alive = true
    var bound = true
    
    var reaction: HitReaction?
    
    init(_ hull: Hull, _ bodyhull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        material = ClassicMaterial()
        material.coordinates = HullLayout(hull).coordinates
        handle = GraphicsInfo(hull, material)
        body = Body(bodyhull, substance)
    }
    
    func compile() {
        Graphics.create(handle)
    }
    
    func update() {}
    
    func render() {}
    
    var bounds: FixedRect {
        return body.shape.getBounds()
    }
    
    deinit {
        handle.active = false
    }
}
