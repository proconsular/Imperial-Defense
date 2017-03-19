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
    let transform: Transform
    
    var display: Display
    let body: Body
    
    var onObject = false
    var alive = true
    
    init(_ hull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        display = Display(hull, GLTexture("white"))
        body = Body(hull, substance)
        display.camera = true
    }
    
    func update() {}
    
    func render() {
        display.render()
    }
    
    var bounds: FixedRect {
        return body.shape.getBounds()
    }
}
