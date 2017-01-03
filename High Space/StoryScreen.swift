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
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2), Camera.size), GLTexture("white"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.01, 0.01, 0.01, 1)
        
        text = Text("This is where the story will go.\nHopefully there are line breaks. We'll see.", FontStyle(defaultFont, float4(1), 52.0), float2(300, 100))
        text.location = float2(Camera.size.x / 2, 400)
        super.init()
    }
    
    override func display() {
        background.render()
        super.display()
        text.render()
    }
    
}
