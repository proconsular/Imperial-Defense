//
//  ShowPointer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/19/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShowPointer {
    let pointer: Display
    var velocity: float2
    var anchor: float2
    var direction: float2
    
    var flicker: Float = 0
    
    init(_ location: float2) {
        self.anchor = location
        velocity = float2()
        direction = float2(0, 1)
        pointer = Display(Rect(location, float2(1.m)), GLTexture("ShowPointer"))
    }
    
    func update() {
        velocity += direction * 0.1.m * Time.delta
        velocity *= 0.95
        pointer.transform.location += velocity
        
        if anchor.y - pointer.transform.location.y < -0.075.m {
            direction = float2(0, -1)
        }
        if anchor.y - pointer.transform.location.y > 0.075.m {
            direction = float2(0, 1)
        }
        
        flicker += Time.delta
        if flicker >= 0.2 {
            flicker = 0
            pointer.color = pointer.color.x == 1 ? float4(14 / 255, 221 / 225, 11 / 255, 1) : float4(1, 1, 1, 1) 
        }
    }
    
    func render() {
        pointer.refresh()
        pointer.render()
    }
    
}
