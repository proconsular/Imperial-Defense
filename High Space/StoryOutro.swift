//
//  StoryOutro.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryOutro: StoryElement {
    
    let outro: ParsedText
    var text: Text
    var index: Int
    
    var button: TextButton!
    
    init() {
        index = 0
        outro = ParsedTextGateway().retrieve(name: "outro")
        text = Text(" ", FontStyle("Lora-Regular", float4(1), 52.0), float2(400, 300))
        button = TextButton(Text("What else?", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) { [unowned self] in
            UserInterface.fade {
                if self.index + 1 < self.outro.sections.count {
                    self.index += 1
                    self.set(self.outro.sections[self.index])
                }else{
                    UserInterface.controller.reduce()
                    UserInterface.space.wipe()
                    UserInterface.space.push(Splash())
                }
            }
        }
        set(outro.sections[index])
        text.location = float2(Camera.size.x / 2, Camera.size.y * 0.75) + float2(0, -GameScreen.size.y)
    }
    
    func set(_ section: Section) {
        text.setString(section.text)
    }
    
    func update() {
        
    }
    
    func render() {
        text.render()
    }
    
}
