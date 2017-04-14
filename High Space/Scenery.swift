//
//  Scenery.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/10/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Scenery {
    
    let castle: Background
    let floor: Background
    
    init(_ map: Map) {
        let height: Float = 256
        let cr = Rect(float2(map.size.x / 2, -height / 2), float2(map.size.x, height))
        castle = Background(cr, float2(1, 1), "stonefloor")
        castle.display.color = float4(1, 1, 1, 1)
        
        let fr = Rect(float2(GameScreen.size.x / 2, -GameScreen.size.y / 2), GameScreen.size)
        floor = Background(fr, float2(1, 1), "rockfloor")
        floor.display.color = float4(1, 1, 1, 1)
    }
    
    func render() {
        floor.display.render()
        castle.display.render()
    }
    
}

class Background {
    
    let display: Display
    
    init(_ rect: Rect, _ scale: float2, _ texture: String) {
        display = Display(rect, GLTexture(texture))
        display.scheme.schemes[0].layout.coordinates = [float2(0, 0),  float2(0, scale.y), scale, float2(scale.x, 0)]
        display.scheme.schemes[0].order = -2
    }
    
}
