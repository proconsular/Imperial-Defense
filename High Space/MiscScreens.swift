//
//  MiscScreens.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Settings: Screen {
    
    let challenge: Selection
    let tutorial: Selection
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        let vert = float2(0, 150)
        let off = float2(0, 50)
        
        let list = ["Least", "Lesser", "True"]
        challenge = Selection(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y) - vert + off, 400, list)
        tutorial = Selection(float2(Camera.size.x / 2, Camera.size.y / 2 - Camera.size.y) + vert + off, 300, ["Off", "On"])
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(float2(Camera.size.x / 2, Camera.size.y * 0.1 - GameScreen.size.y) , "Settings", FontStyle(defaultFont, float4(1), 128)))
        
        let spacing = float2(800, 0)
        let offset = float2(0, 475 - GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Title", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layer.objects.append(Text(float2(Camera.size.x / 2, Camera.size.y / 2 - 105 - Camera.size.y) - vert + off, "Challenge", FontStyle(defaultFont, float4(1), 72)))
        
        layer.objects.append(Text(float2(Camera.size.x / 2, Camera.size.y / 2 - 105 - Camera.size.y) + vert + off, "Tutorial", FontStyle(defaultFont, float4(1), 72)))
        
        for button in challenge.buttons {
            layer.objects.append(button)
        }
        
        challenge.select(GameData.info.challenge + 2)
        tutorial.select(GameData.info.tutorial ? 1 : 0)
        
        for button in tutorial.buttons {
            layer.objects.append(button)
        }
        
        layers.append(layer)
    }
    
    override func update() {
        super.update()
        let c = GameData.info.challenge
        if c != challenge.index - 2 {
            GameData.info.challenge = challenge.index - 2
            GameData.persist()
        }
        
        let t = GameData.info.tutorial ? 1 : 0
        if t != tutorial.index {
            GameData.info.tutorial = tutorial.index == 1
            GameData.persist()
        }
    }
    
}

class Selection {
    var buttons: [TextButton]
    var index: Int
    
    init(_ location: float2, _ spacing: Float, _ options: [String]) {
        buttons = []
        index = 0
        
        for i in 0 ..< options.count {
            let option = options[i]
            let button = TextButton(Text(option, FontStyle(defaultFont, float4(1), 76)), float2(Float(i) * spacing - spacing * Float(options.count) / 2 + spacing / 2, 0) + location, { [unowned self] in
                self.select(i)
            })
            buttons.append(button)
        }
    }
    
    func select(_ index: Int) {
        self.index = index
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            button.text.color = float4(index == i ? 1 : 0.5)
            button.text.text.display.refresh()
        }
    }
    
}
















