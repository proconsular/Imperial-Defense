//
//  TitleScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TitleScreen: Screen {
    let background: Display
    
    override init() {
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2), Camera.size), GLTexture("stonefloor"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.7, 0.7, 0.7, 1)
        background.scheme.camera = false
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let spread: Float = 200
        let size: Float = 72
        
        let style = FontStyle(defaultFont, float4(1), size)
        
        layer.objects.append(TextButton(Text("Story", style), float2(Camera.size.x / 2, Camera.size.y / 2 - spread)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Forever", style), float2(Camera.size.x / 2, Camera.size.y / 2)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Reset", style), float2(Camera.size.x / 2, Camera.size.y / 2 + spread)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
    }
    
}
