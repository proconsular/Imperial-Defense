//
//  LevelScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LevelScreen: Screen {
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(Text(float2(Camera.size.x / 2, Camera.size.y * 0.1 - GameScreen.size.y) , "Levels", FontStyle(defaultFont, float4(1), 128)))
        
        let rowLength = 6
        for i in 0 ..< 20 {
            let index = (i + 1) * 5
            let location = float2(Float(i % rowLength) * 200, 200 * Float(Int(Float(i) / Float(rowLength)))) + float2(Camera.size.x / 4, -Camera.size.y * 0.75)
            let button = TextButton(Text("\(index)", FontStyle(defaultFont, float4(1), 72)), location) { [unowned self] in
                self.setLevel(index)
            }
            layer.objects.append(button)
        }
        
        let index = 101
        let location = float2(Camera.size.x / 2, -Camera.size.y * 0.1)
        let button = TextButton(Text("\(index)", FontStyle(defaultFont, float4(1), 72)), location) { [unowned self] in
            self.setLevel(index)
        }
        layer.objects.append(button)
        
        let spacing = float2(800, 0)
        let offset = float2(0, 475 - GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Title", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layers.append(layer)
    }
    
    func setLevel(_ index: Int) {
        switch index {
        case 5:
            LevelDebugConfig.debug(index, 0, 1)
        case 10:
            LevelDebugConfig.debug(index, 1, 1)
        case 15:
            LevelDebugConfig.debug(index, 1, 2)
        case 20:
            LevelDebugConfig.debug(index, 2, 3)
        case 25:
            LevelDebugConfig.debug(index, 3, 3)
        case 30:
            LevelDebugConfig.debug(index, 3, 4)
        case 35:
            LevelDebugConfig.debug(index, 4, 4)
        case 40:
            LevelDebugConfig.debug(index, 4, 5)
        case 45:
            LevelDebugConfig.debug(index, 5, 5)
        default:
            LevelDebugConfig.debug(index, 5, 5)
            break
        }
    }
    
}
