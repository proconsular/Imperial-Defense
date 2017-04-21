//
//  Splash.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/15/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Splash: Screen {
    
    let background: Display
    
    override init() {
        background = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash"))
        //background.color = float4(0.05, 0.05, 0.075, 1)
        //background.camera = false
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let smallstyle = FontStyle(defaultFont, float4(1, 1, 1, 1), 36)
        let titlestyle = FontStyle(defaultFont, float4(1, 1, 1, 1), 128.0)
        
        let margin: Float = 35
        
        let storiel = Text(float2(Camera.size.x / 2, margin) + float2(0, -GameScreen.size.y), "a storiel game", smallstyle)
        let copyright = Text(float2(Camera.size.x / 2, Camera.size.y - margin) + float2(0, -GameScreen.size.y), "Copyright © 2017 Storiel, LLC. All rights reserved.", smallstyle)
        let title = Text(float2(Camera.size.x / 2, Camera.size.y / 2 - 150) + float2(0, -GameScreen.size.y), "Imperial Defense", titlestyle)
        
        layer.objects.append(storiel)
        layer.objects.append(copyright)
        layer.objects.append(title)
        layer.objects.append(TextButton(Text("Tap to Play", FontStyle(defaultFont, float4(1, 1, 1, 1), 72)), float2(Camera.size.x / 2, Camera.size.y / 2 + 50) + float2(0, -GameScreen.size.y)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Reset", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
            GameData.info = GameInfo.Default
            GameData.persist()
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        layers.forEach{$0.display()}
    }
    
}
