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
    var quotes: [StoryQuote]
    var index: Int
    
    var button: TextButton!
    
    init() {
        index = 0
        outro = ParsedTextGateway().retrieve(name: "outro")
        
        quotes = []
       
        for q in outro.sections where q.text.trimmed != "" {
            quotes.append(StoryQuote(q.text))
        }
        
        button = TextButton(Text("What else?", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) { [unowned self] in
            UserInterface.fade {
                if self.index + 1 < self.outro.sections.count {
                    self.index += 1
                }else{
                    UserInterface.controller.reduce()
                    UserInterface.space.wipe()
                    UserInterface.space.push(Splash())
                }
            }
        }
        
    }
    
    func update() {
        
    }
    
    func render() {
        quotes[index].render()
    }
    
}
