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
        background = Display(Rect(float2(Camera.size.x / 2, -Camera.size.y / 2), Camera.size), GLTexture())
        background.scheme.schemes[0].layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.1, 0.1, 0.1, 1)
        
        points = Text(" ", defaultStyle)
        points.location = float2(Camera.size.x / 2, 60)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let uspacing = float2(600, 300)
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - uspacing.x, Camera.size.y / 2 - uspacing.y / 2), GameData.info.upgrades[0]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 - uspacing.y / 2), GameData.info.upgrades[1]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + uspacing.x, Camera.size.y / 2 - uspacing.y / 2), GameData.info.upgrades[2]))
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - uspacing.x, Camera.size.y / 2 + uspacing.y / 2), GameData.info.upgrades[3]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 + uspacing.y / 2), GameData.info.upgrades[4]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + uspacing.x, Camera.size.y / 2 + uspacing.y / 2), GameData.info.upgrades[5]))
        
        let spacing = float2(350, 0)
        let offset = float2(0, 450)
        
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
    
    override func display() {
        background.render()
        points.setString("\(GameData.info.points)")
        points.render()
        super.display()
    }
}
