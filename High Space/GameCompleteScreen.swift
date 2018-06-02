//
//  GameCompleteScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/1/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GameCompleteScreen: Screen {
    
    let background: Display
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture())
        background.camera = false
        background.color = float4(0, 0, 0, 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -400) + float2(0, -GameScreen.size.y), "VICTORIUM SUMPREMUM", FontStyle(defaultFont, float4(1), 144)))
        
        let text = """
        You've obtained supreme victory and have pacified \n!@#%#&^# and !^#$&%##!@#%. \n
        Thank you for playing and being a clearly excellent player!
        """
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 250) + float2(0, -GameScreen.size.y), text, FontStyle(defaultFont, float4(1), 64), float2(400, 200)))
        
        layer.objects.append(TextButton(Text("Return to Title", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + float2(0, GameScreen.size.y * 0.4) + float2(0, -GameScreen.size.y), {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
    }
}
