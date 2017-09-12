//
//  GameUI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PauseScreen: Screen {
    
    var background: Display
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(GameScreen.size / 2, GameScreen.size, GLTexture())
        background.color = float4(0.75) * float4(0, 0, 0, 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextButton(Text("Resume", FontStyle(defaultFont, float4(1), 84)), GameScreen.size / 2 + float2(0, -100) + float2(0, -GameScreen.size.y)) {
            UserInterface.space.pop()
            UserInterface.controller.reduce()
        })
        
        layer.objects.append(TextButton(Text("Menu", FontStyle(defaultFont, float4(1), 84)), GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y)) {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
    }
    
}






