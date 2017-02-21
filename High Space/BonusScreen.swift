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
        
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture())
        background.scheme.camera = false
        background.color = float4(0.75) * float4(0, 0, 0, 1)
        
        timer = 10
        text = Text(Camera.size / 2 - offset, "Time: 0", defaultStyle)
        
        super.init()
        
        let layer = InterfaceLayer()
        
//        layer.objects.append(text)
      
        layer.objects.append(TextButton(Text("Repair (50)", FontStyle(defaultFont, float4(1), 52)), Camera.size / 2 - spacing) {
            if Data.info.points >= 50 {
                Data.info.points -= 50
                game.barriers.forEach{ $0.destroy() }
                game.createBarriers(3, -2.8.m, int2(10, 4))
            }
        })
        
        layer.objects.append(TextButton(Text("Super Shield (75)", FontStyle(defaultFont, float4(1), 52)), Camera.size / 2) {
            if Data.info.points >= 75 {
                Data.info.points -= 75
                game.player.shield.points.overcharge(amount: 2)
            }
        })
        
        layer.objects.append(TextButton(Text("Super Power (100)", FontStyle(defaultFont, float4(1), 52)), Camera.size / 2 + spacing) {
            if Data.info.points >= 100 {
                Data.info.points -= 100
                game.player.weapon.overcharge(amount: 25)
            }
        })
        
        layer.objects.append(TextButton(Text("Save Half"), Camera.size / 2 + offset - float2(200, 0)) {
            Data.info.bank += Data.info.points / 2
            Data.info.points = Data.info.points / 2
            Data.persist()
            UserInterface.space.pop()
        })
        
        layer.objects.append(TextButton(Text("Continue"), Camera.size / 2 + offset + float2(200, 0)) {
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



