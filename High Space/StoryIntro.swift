//
//  StoryIntro.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryIntro: StoryElement {
    
    var phrases: [StoryPhrase]
    
    var counter: Float
    var index: Int
    
    var delay: Float = 0
    
    var opacity: Float
    var speed: Float
    var direction: Float
    var fading: Bool
    
    let button: TextButton
    
    init() {
        phrases = []
        
        phrases.append(StoryPhrase(4, "You."))
        phrases.append(StoryPhrase(8, "You are the last one."))
        phrases.append(StoryPhrase(15,
        "The empress has retreated to her imperial castle.\nWounded and dreadfully immobilized from great war and fight.\nThe evil empire marches against us.\nNo one is left."))
        phrases.append(StoryPhrase(15,
        "The emprate wrecked\nand its imperial legions turned to ash.\nThere is no one left."))
        phrases.append(StoryPhrase(15,
        "The senate’s proconsuls defeated and captured. Who is left?\nThe empress’ cohorts are slain and utterly routed.\nWho will go?"))
        phrases.append(StoryPhrase(15, "There only remains one. One last imperial legate of the empress."))
        phrases.append(StoryPhrase(10, "And that is you. You are the last one."))
        phrases.append(StoryPhrase(10, "Will you fight?"))
        
        counter = 0
        index = 0
        opacity = 0
        direction = 1
        speed = 1.5
        fading = true
        
        button = TextButton(Text("With all my heart!", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(PrincipalScreen())
            }
        }
        button.text.color = float4(0)
        
    }
    
    var phrase: StoryPhrase {
        return phrases[index]
    }
    
    func update() {
        
        counter += Time.delta
        if counter >= phrase.time && index < phrases.count - 1 {
            counter = 0
            UserInterface.fade { [unowned self] in
                self.index += 1
            }
        }
        
        if index == phrases.count - 1 {
            delay += Time.delta
            if delay >= 3.5 {
                button.text.color = float4(clamp(button.text.color.w + speed * Time.delta, min: 0, max: 1))
                button.text.text.display.refresh()
            }
        }
        
//        opacity = clamp(opacity + speed * direction * Time.delta, min: 0, max: 1)
//        text.color = float4(opacity)
//        text.text.display.refresh()
    }
    
    func render() {
        phrases[index].render()
    }
    
}

class StoryPhrase {
    let time: Float
    let content: String
    let quote: StoryQuote
    
    init(_ time: Float, _ content: String) {
        self.time = time
        self.content = content
        quote = StoryQuote(content, float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y))
    }
    
    func render() {
        quote.render()
    }
}

