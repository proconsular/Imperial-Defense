//
//  StoryScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryScreen: Screen {
    let background: Display
    var text: Text
    
    override init() {
        UserInterface.controller.push(PointController(0))
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y), Camera.size), GLTexture("white"))
        background.color = float4(0.01, 0.01, 0.01, 1)
        
        let words = "You... You are the last one.\nThe Empress has retreated to her imperial castle. Wounded and dreadfully immobilized from great war and fight. The evil empire marches against us. No one is left, no not one. The emprate wrecked and its imperial legions turned to ash. There is no one left. The senate’s proconsuls defeated and captured. Who is left? The empress’ cohorts are slain and utterly routed. Who will go?\nThere only remains one. One last imperial legate of the Empress.\nAnd that is you. You are the last one.\nWill you fight?"
        
        text = Text(words, FontStyle("Lora-Regular", float4(1), 52.0), float2(400, 200))
        text.location = float2(Camera.size.x / 2, 600) + float2(0, -GameScreen.size.y)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextButton(Text("With all my heart!", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(PrincipalScreen())
            }
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
        text.render()
    }
    
}
