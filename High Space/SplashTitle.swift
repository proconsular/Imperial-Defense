//
//  SplashElements.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SplashTitle {
    
    let title: Display
    let location: float2
    var velocity: float2
    var direction: Float
    
    init() {
        location = float2(Camera.size.x / 2, Camera.size.y / 2 - 150) + float2(0, -GameScreen.size.y)
        title = Display(Rect(location, float2(1598, 151)), GLTexture("Title"))
        velocity = float2()
        direction = 1
    }
    
    func update() {
        velocity.y += 0.015 * direction
        velocity.y *= 0.99
        title.transform.location.y += velocity.y
        let delta = title.transform.location.y - location.y
        if delta < -2 {
            direction = 1
        }
        if delta > 2 {
            direction = -1
        }
        title.refresh()
    }
    
    func render() {
        title.render()
    }
    
}
















