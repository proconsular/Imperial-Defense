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
        
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture())
        background.camera = false
        background.color = float4(0, 0, 0, 1)
        
        quote = StoryQuote("Legion \(Coordinator.wave.roman) has obliterated the castle and killed the Empress.\n Absolute Defeat.", GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -200) + float2(0, -GameScreen.size.y), win ? "Victory!" : "DEFEATUM ABSOLUTUM", FontStyle("Augustus", float4(1), 128)))
        //layer.objects.append(Text(Camera.size / 2 + float2(-200, 100), "Level \(GameData.info.level + 1)", FontStyle(defaultFont, float4(1), 72)))
        
//        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -50) + float2(0, -GameScreen.size.y), "Legio \(Coordinator.wave.roman)", FontStyle(defaultFont, float4(1), 72)))
//        layer.objects.append(Text(GameScreen.size / 2 + float2(200, -100) + float2(0, -GameScreen.size.y), "Crystal \(GameData.info.points)", FontStyle(defaultFont, float4(1), 72)))
//        let text = Text(GameScreen.size / 2 + float2(0, 200) + float2(0, -GameScreen.size.y), "Legio \(Coordinator.wave.roman) has crushed you. The castle has been raided and the Empress captured. You have failed.", FontStyle(defaultFont, float4(1), 48), float2(300, 50))
//        text.location = Camera.size / 2 + float2(150 / 4, 100) + float2(0, -GameScreen.size.y)
//        layer.objects.append(text)
        
        let spacing = float2(500, 0)
        let offset = float2(0, 450) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Escape", FontStyle("Augustus", float4(1), 64)), GameScreen.size / 2 + offset - spacing, {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layer.objects.append(TextButton(Text("Defend", FontStyle("Augustus", float4(1), 64)), GameScreen.size / 2 + offset + spacing, {
            UserInterface.fade {
                UserInterface.controller.reduce()
                let pr = PrincipalScreen()
                UserInterface.space.wipe()
                UserInterface.space.push(pr)
            }
        }))
        
        layers.append(layer)
        
        let audio = Audio("Defeat")
        audio.loop = true
        audio.start()
    }
    
    deinit {
        let audio = Audio("Defeat")
        audio.stop()
    }
    
    override func display() {
        background.render()
        super.display()
        quote.render()
    }
    
}

class GameCompleteScreen: Screen {
    
    let background: Display
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture())
        background.camera = false
        background.color = float4(0, 0, 0, 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -100) + float2(0, -GameScreen.size.y), "You Won!", FontStyle(defaultFont, float4(1), 144)))
        
        let spacing = float2(250, 0)
        
        layer.objects.append(TextButton(Text("The Empress!", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 - spacing + float2(0, -GameScreen.size.y), {
            UserInterface.space.wipe()
            UserInterface.controller.reduce()
            UserInterface.space.push(StoryScreen(StoryOutro()))
        }))
        
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







