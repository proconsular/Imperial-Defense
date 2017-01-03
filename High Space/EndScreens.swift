//
//  EndScreens.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EndScreen: Screen {
    
    enum Ending {
        case victory, lose
    }
    
    init(ending: Ending) {
        super.init()
        
        let layer = InterfaceLayer()
        
        var text = ""
        
        if case .victory = ending {
            text = "Victory!"
        }else{
            text = "You died."
        }
        
        layer.objects.append(Text(Camera.size / 2, text, FontStyle(defaultFont, float4(1), 128)))
        layer.objects.append(TextButton(Text("Restart", FontStyle(defaultFont, float4(1), 86)), Camera.size / 2 + float2(0, 400), {
            UserInterface.space.wipe()
            UserInterface.push(StoreScreen())
        }))
        
        layers.append(layer)
    }
    
}

class WinScreen: Screen {
    
    override init() {
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(Camera.size / 2, "You Won!", FontStyle(defaultFont, float4(1), 128)))
        layer.objects.append(TextButton(Text("Next", FontStyle(defaultFont, float4(1), 86)), Camera.size / 2 + float2(0, 400), {
            Data.info.level += 1
            Data.persist()
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
        }))
        
        layers.append(layer)
    }
    
}
