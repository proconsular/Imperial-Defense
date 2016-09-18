//
//  LightingSystem.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/29/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class LightingSystem {
    
    let lighting: Lighting
    let light: Light
    let ambient: Display
    
    init (_ grid: Grid) {
        ambient = Display(Rect(Camera.size / 2, Camera.size), GLTexture("white"))
        ambient.color = float4(0.1, 0.1, 0.1, 0.7)
        ambient.transform.assign(Camera.transform)
        
        lighting = Lighting(grid)
        light = Light(float2(2.m, -2.m), 1.25, -0.005, 40000, -0.0001, float4(1, 1, 1, 1))
        
        lighting.lights.append(light)
    }
    
    func render() {
        light.location = Player.player.transform.location
        light.display.transform.location = Player.player.transform.location
        ambient.render()
        lighting.render()
        
    }
    
}
