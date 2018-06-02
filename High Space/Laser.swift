//
//  Laser.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Laser {
    
    var rect: Polygon
    var display: Display
    var transform: Transform
    var direction: float2
    var visible: Bool
    let bounds: float2
    
    var side: Display
    var audio: AudioDelegate?
    
    var color_first, color_second: float4
    
    init(_ location: float2, _ width: Float, _ direction: float2) {
        self.transform = Transform(location)
        self.direction = direction
        bounds = float2(Camera.size.y * 1.5, width)
        rect = Polygon(self.transform, [float2(0, -bounds.y * 0.25), float2(0, bounds.y * 0.25), float2(bounds.x, bounds.y * 8), float2(bounds.x, -bounds.y * 8)])
        display = Display(rect, GLTexture("white"))
        display.color = float4(1, 0, 0, 1)
        color_first = float4(0.8, 0, 1, 1)
        color_second = float4(0.4, 0, 0.4, 0.4)
        side = Display(Rect(Transform(float2()), float2(Camera.size.y * 1.5, 50)), GLTexture("laser"))
        visible = false
    }
    
    func update() {
        let angle = atan2(direction.y, direction.x)
        let a = angle - 0.1
        let loc = transform.location
        rect.transform.location = loc + float2(bounds.x / 2, bounds.x / 2) * direction
        side.transform.location = loc + float2(bounds.x / 2, bounds.x / 2) * float2(cosf(a), sinf(a)) + float2(0.3.m, 0)
        rect.transform.orientation = angle
        side.transform.orientation = a
        let rand = arc4random() % 2
        display.color = rand == 0 ? color_first : color_second
        side.color = display.color
        side.refresh()
        audio?.play()
    }
    
    func render() {
        if visible {
            display.visual.refresh()
            display.render()
        }
    }
    
}
