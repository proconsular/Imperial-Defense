//
//  Scenery.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/10/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Scenery {
    
    let castle: Castle
    let floor: Render
    
    init(_ barriers: [Wall]) {
        let height: Float = 256
        castle = Castle(float2(Camera.size.x / 2, -height / 2))
        castle.barriers = barriers
        
        floor = Display(Rect(float2(GameScreen.size.x / 2, -GameScreen.size.y / 2), GameScreen.size), GLTexture("rockfloor"))
    }
    
    func update() {
        castle.update()
    }
    
    func render() {
        floor.render()
        castle.render()
    }
    
}








