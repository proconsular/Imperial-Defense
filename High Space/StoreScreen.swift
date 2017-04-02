//
//  StoreScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoreScreen: Screen {
    let background: Display
    let points: Text
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(float2(GameScreen.size.x / 2, GameScreen.size.y / 2), GameScreen.size, GLTexture())
        background.scheme.schemes[0].layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.1, 0.1, 0.1, 1)
        
        points = Text(" ", defaultStyle)
        points.location = float2(Camera.size.x / 2, 60 - GameScreen.size.y)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let uspacing = float2(600, 0)
        
        layer.objects.append(UpgradeView(float2(GameScreen.size.x / 2 - uspacing.x, GameScreen.size.y / 2 - uspacing.y / 2), upgrader.firepower))
        layer.objects.append(UpgradeView(float2(GameScreen.size.x / 2, GameScreen.size.y / 2 - uspacing.y / 2), upgrader.shieldpower))
        layer.objects.append(UpgradeView(float2(GameScreen.size.x / 2 + uspacing.x, GameScreen.size.y / 2 - uspacing.y / 2), upgrader.barrier))
        
        let spacing = float2(350, 0)
        let offset = float2(0, 450 - GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Menu", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
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
        points.setString("\(GameData.info.points)")
        points.render()
        super.display()
    }
}
