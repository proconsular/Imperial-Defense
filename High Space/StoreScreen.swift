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
        background = Display(Rect(float2(Camera.size.x / 2, -Camera.size.y / 2), Camera.size), GLTexture("stonefloor"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.7, 0.7, 0.7, 1)
        
        points = Text(" ", defaultStyle)
        points.location = float2(Camera.size.x / 2, 60)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let spacing = float2(600, 400)
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - spacing.x, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[0]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[1]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + spacing.x, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[2]))
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - spacing.x, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[3]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[4]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + spacing.x, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[5]))
        
        layer.objects.append(TextButton(Text("Next", defaultStyle), float2(Camera.size.x / 2, Camera.size.y - 50)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layers.append(layer)
        
    }
    
    override func display() {
        background.render()
        points.setString("\(Data.info.points)")
        points.render()
        super.display()
    }
}
