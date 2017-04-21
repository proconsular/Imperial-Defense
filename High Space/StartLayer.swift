//
//  StartLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/16/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StartPrompt: Screen {
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let wave = GameData.info.wave + 1
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -100) + float2(0, -GameScreen.size.y), "Legio \(wave.roman)", FontStyle(defaultFont, float4(1), 144)))
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y), "Legio \(wave.roman) wants to battle. Will you accept?", FontStyle(defaultFont, float4(1), 36)))
        
        let offset = float2(0, 350) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Battle", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset, {
            UserInterface.space.pop()
            if let princ = UserInterface.space.contents[0] as? PrincipalScreen {
                princ.game.physics.unhalt()
            }
        }))
        
        layers.append(layer)
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
}

class EndPrompt: Screen {
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let wave = GameData.info.wave + 1
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -100) + float2(0, -GameScreen.size.y), "Legio \(wave.roman)", FontStyle(defaultFont, float4(1), 144)))
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y), "Legio \(wave.roman) has been destroyed.", FontStyle(defaultFont, float4(1), 36)))
        
        let offset = float2(0, 350)
        
        layer.objects.append(TextButton(Text("Forge", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset + float2(-300, -GameScreen.size.y), {
            UserInterface.space.wipe()
            UserInterface.push(StoreScreen())
        }))
        
        layer.objects.append(TextButton(Text("Play", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset + float2(300, -GameScreen.size.y), {
            UserInterface.space.wipe()
            UserInterface.push(PrincipalScreen())
        }))
        
        layers.append(layer)
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
}
