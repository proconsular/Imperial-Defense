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
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture("Splash"))
        //background.color = float4(0.05, 0.05, 0.075, 1)
        background.scheme.camera = false
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let smallstyle = FontStyle(defaultFont, float4(0, 0, 0, 1), 36)
        let titlestyle = FontStyle(defaultFont, float4(0, 0, 0, 1), 128.0)
        
        let margin: Float = 35
        
        let storiel = Text(float2(Camera.size.x / 2, margin), "a storiel game", smallstyle)
        storiel.text.display.display.scheme.camera = false
        let copyright = Text(float2(Camera.size.x / 2, Camera.size.y - margin), "Copyright © 2017 Storiel, LLC. All rights reserved.", smallstyle)
        copyright.text.display.display.scheme.camera = false
        let title = Text(float2(Camera.size.x / 2, Camera.size.y / 2), "Imperial Defense", titlestyle)
        title.text.display.display.scheme.camera = false
        
        layer.objects.append(storiel)
        layer.objects.append(copyright)
        layer.objects.append(title)
        layer.objects.append(TextButton(Text("Tap to Play"), float2(Camera.size.x / 2, Camera.size.y / 2 + 200)) {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        layers.forEach{$0.display()}
    }
    
}
