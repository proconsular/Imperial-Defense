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
    
    init(_ win: Bool) {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture())
        background.scheme.camera = false
        background.color = float4(0.75) * float4(0, 0, 0, 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(Camera.size / 2 + float2(0, -100), win ? "Victory!" : "Defeat!", FontStyle(defaultFont, float4(1), 144)))
        layer.objects.append(Text(Camera.size / 2 + float2(-200, 100), "Level \(Data.info.level + 1)", FontStyle(defaultFont, float4(1), 72)))
        layer.objects.append(Text(Camera.size / 2 + float2(200, 100), "Points \(Data.info.points)", FontStyle(defaultFont, float4(1), 72)))
        
        let spacing = float2(350, 0)
        let offset = float2(0, 450)
        
        layer.objects.append(TextButton(Text("Menu", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
        }))
        
        layer.objects.append(TextButton(Text("Upgrades", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset, {
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
        }))
        
        layer.objects.append(TextButton(Text("Play", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset + spacing, {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
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







