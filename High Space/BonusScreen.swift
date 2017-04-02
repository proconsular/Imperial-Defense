//
//  BonusLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BonusScreen: Screen {
    
    var timer: Float
    
    let text: Text
    
    let background: Display
    
    init(_ game: Game) {
        UserInterface.controller.push(PointController(0))
        
        let spacing = float2(550, 0)
        let offset = float2(0, 400)
        
        background = Display(GameScreen.size / 2, GameScreen.size, GLTexture())
        background.camera = false
        background.color = float4(0.75) * float4(0, 0, 0, 1)
        
        timer = 10
        text = Text(GameScreen.size / 2 - offset + float2(0, -GameScreen.size.y), "Time: 0", defaultStyle)
        
        super.init()
        
        let layer = InterfaceLayer()
        
//        layer.objects.append(text)
      
      
        layer.objects.append(TextButton(Text("Continue"), GameScreen.size / 2 + offset + float2(0, -GameScreen.size.y)) {
            UserInterface.space.pop()
        })
        
        layers.append(layer)
        
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
    override func update() {
        super.update()
//        timer = max(timer - Time.time, 0)
//        text.setString("Time: \(Int(timer))")
//        
//        if timer == 0 {
//            UserInterface.space.pop()
//        }
    }
    
    override func display() {
        background.render()
        super.display()
    }
    
}



