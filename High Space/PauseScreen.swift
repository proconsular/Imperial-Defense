//
//  GameUI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PauseScreen: Screen {
    
    let background: Display
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture())
        background.scheme.camera = false
        background.color = float4(0.75) * float4(0, 0, 0, 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextButton(Text("Resume", FontStyle(defaultFont, float4(1), 84)), Camera.size / 2 + float2(0, -100)) {
            UserInterface.space.pop()
        })
        
        layer.objects.append(TextButton(Text("Menu", FontStyle(defaultFont, float4(1), 84)), Camera.size / 2 + float2(0, 100)) {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
        })
        
        layers.append(layer)
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
    override func display() {
        background.render()
        super.display()
    }
    
}









