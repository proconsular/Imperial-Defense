//
//  GameUI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PauseScreen: Screen {
    
    override init() {
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextButton(Text("Resume", defaultStyle), Camera.size / 2 + float2(0, -75)) {
            UserInterface.space.pop()
        })
        
        layer.objects.append(TextButton(Text("Title", defaultStyle), Camera.size / 2 + float2(0, 75)) {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
        })
        
        layers.append(layer)
    }
    
}









