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
        let height = 2.5.m
        let cr = Rect(float2(map.size.x / 2, -height / 2), float2(map.size.x, height))
        castle = Background(cr, float2(12, 2), "stonefloor")
        castle.display.color = float4(1, 1, 1, 1)
        
        let fr = Rect(float2(map.size.x / 2, -map.size.y / 2), map.size)
        floor = Background(fr, float2(3, 6) * 4, "rockfloor")
        floor.display.color = float4(0.5, 0.4, 0.4, 1)
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
        display.scheme.layout.coordinates = [float2(0, 0),  float2(0, scale.y), scale, float2(scale.x, 0)]
    }
    
}
