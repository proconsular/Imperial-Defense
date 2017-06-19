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
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y), Camera.size), GLTexture("white"))
        //background.scheme.schemes[0].layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.01, 0.01, 0.01, 1)
        
        let words = "The empress has retreated to her imperial castle. Wounded and dreadfully immobilized from great war and fight. The evil empire marches against us. No one is left, no not one. The emprate wrecked and its imperial legions turned to ash. There is no one left. The senate’s proconsuls defeated and captured. Who is left? The empress’ cohorts are slain and utterly routed. Who will go?"
        
        text = Text(words, FontStyle("Lora-Regular", float4(1), 52.0), float2(300, 200))
        text.location = float2(Camera.size.x / 2, 700) + float2(0, -GameScreen.size.y)
        super.init()
    }
    
    override func display() {
        background.render()
        super.display()
        text.render()
    }
    
}
