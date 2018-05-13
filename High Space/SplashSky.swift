//
//  SplashSky.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SplashSky {
    
    let sky_color: float4
    let sky: Display
    var fade: Float
    
    
    init() {
        sky_color = float4(6 / 255, 14 / 255, 39 / 255, 1)
        sky = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("white"))
        sky.color = sky_color
        fade = 1
    }
    
    func update() {
        if random(0, 1) < 0.001 {
            fade = 0
            let thunder = Audio("thunder")
            thunder.pitch = random(0.9, 1.1)
            thunder.volume = sound_volume * 0.5
            thunder.start()
        }
        
        fade = clamp(fade + 2 * Time.delta, min: 0, max: 1)
        sky.color = sky_color * fade + float4(1) * (1 - fade)
    }
    
    func render() {
        sky.refresh()
        sky.render()
        
    }
    
}
