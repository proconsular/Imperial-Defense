//
//  Actor.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Actor {
    let transform: Transform
    
    let display: Display
    let body: Body
    
    var onObject = false
    var alive = true
    
    var order = 0
    
    init(_ hull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        display = Display(hull, GLTexture("white"))
        body = Body(hull, substance)
        display.scheme.camera = true
    }
    
    func update() {}
    
    func render() {
        display.render()
    }
}
