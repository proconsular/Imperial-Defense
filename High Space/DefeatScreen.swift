//
//  EndScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EndScreen: Screen {
    
    let background: Display
    let quote: StoryQuote
    var opacity: Float = 0
    
    init(_ win: Bool) {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture("Background"))
        
        var text = "Legion \(Coordinator.wave.roman) has overtaken you.\n Absolute Defeat."
        if GameData.info.wave + 1 >= 101 {
            text = "??? has overtaken you.\n Absolute Defeat."
        }
        quote = StoryQuote(text, GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -200) + float2(0, -GameScreen.size.y), win ? "Victory!" : "DEFEATUM ABSOLUTUM", FontStyle("Augustus", float4(1), 128)))
        
        let spacing = float2(500, 0)
        let offset = float2(0, 450) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(BorderedButton(Text("Title", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset - spacing, float2(8, -16), GLTexture("ButtonBorder"), {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layer.objects.append(BorderedButton(Text("Play", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset + spacing, float2(8, -16), GLTexture("ButtonBorder"), {
            UserInterface.fade {
                UserInterface.controller.reduce()
                let pr = PrincipalScreen()
                UserInterface.space.wipe()
                UserInterface.space.push(pr)
            }
        }))
        
        layers.append(layer)
        
        MusicSystem.instance.flush()
        MusicSystem.instance.append(MusicEvent("Defeat", true))
    }
    
    override func display() {
        background.render()
        super.display()
        quote.render()
    }
    
}






