//
//  Actor.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Actor {
    var alive: Bool { get set }
    func update()
}

class Entity: Actor {
    unowned let transform: Transform
    
    let handle: RenderHandle
    var material: ClassicMaterial
    let body: Body
    
    var onObject = false
    var alive = true
    var bound = true
    
    init(_ hull: Hull, _ bodyhull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        material =  ClassicMaterial()
        material.coordinates = HullLayout(hull).coordinates
        handle = Graphics.create(GraphicsInfo(hull, material))
        body = Body(bodyhull, substance)
    }
    
    func update() {
        
    }
    
    func render() {
        //display.render()
    }
    
    var bounds: FixedRect {
        return body.shape.getBounds()
    }
    
    deinit {
        handle.destroy()
    }
}
