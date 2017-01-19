//
//  TitleScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TitleScreen: Screen {
    let background: Background
    
    override init() {
        background = Background(Rect(float2(Camera.size.x / 2, Camera.size.y / 2), Camera.size), float2(12, 2), "stonefloor")
        
        super.init()
        
        layers.append(TitleLayer())
    }
    
    override func display() {
        //background.display.render()
        super.display()
    }
    
}

class TitleLayer: InterfaceLayer {
    
    var buttons: [TextButton]
    var current: Int
    
    var elements: [InterfaceElement]
    
    let offset = float2(400, 500)
    
    override init() {
        buttons = []
        current = 1
        
        elements = []
        
        elements.append(FriendsDisplay())
        elements.append(GameDisplay())
        elements.append(NewsDisplay())
        
        super.init()
        
        
        buttons.append(TextButton(Text("Friends"), float2(Camera.size.x / 2 - offset.x, Camera.size.y / 2 + offset.y)) {
            self.current = 0
        })
        
        buttons.append(TextButton(Text("Play"), float2(Camera.size.x / 2, Camera.size.y / 2 + offset.y)) {
            if self.current == 1 {
                UserInterface.space.wipe()
                UserInterface.push(PrincipalScreen())
            }
            self.current = 1
        })
        
        buttons.append(TextButton(Text("News"), float2(Camera.size.x / 2 + offset.x, Camera.size.y / 2 + offset.y)) {
            self.current = 2
        })
        
        buttons.forEach {
            objects.append($0)
        }
        
        objects.append(Text(float2(Camera.size.x / 2, 50), "Imperial Defense", FontStyle(defaultFont, float4(1), 48.0)))
        
    }
    
    override func update() {
        for n in 0 ..< buttons.count {
            let button = buttons[n]
            let delta = n - current
            let location =  float2(Camera.size.x / 2 + offset.x * Float(delta), Camera.size.y / 2 + offset.y)
            let dl = location - button.location
            button.location += dl / 4
            button.update()
        }
    }
    
    override func use(_ command: Command) {
        super.use(command)
        (elements[current] as? Interface)?.use(command)
    }
    
    override func display() {
        elements[current].render()
        super.display()
    }
    
}











