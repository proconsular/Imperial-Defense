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
    
    var text: Text
    
    let button: TextButton
    
    init() {
        phrases = []
        
        phrases.append(StoryPhrase(4, "You."))
        phrases.append(StoryPhrase(8, "You are the last one."))
        phrases.append(StoryPhrase(35, "The empress has retreated to her imperial castle. Wounded and dreadfully immobilized from great war and fight. The evil empire marches against us. No one is left, no not one. The emprate wrecked and its imperial legions turned to ash. There is no one left. The senate’s proconsuls defeated and captured. Who is left? The empress’ cohorts are slain and utterly routed. Who will go?", float2(400, 100)))
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
        
        text = Text(" ", FontStyle("Lora-Regular", float4(1), 52.0), float2(400, 200))
        set(phrase)
        text.color = float4(opacity)
    }
    
    var phrase: StoryPhrase {
        return phrases[index]
    }
    
    func update() {
        
        counter += Time.delta
        if counter >= phrase.time && index < phrases.count - 1 {
            counter = 0
            index += 1
            fading = true
            direction = -1
        }
        
        if fading {
            if direction == -1 {
                if opacity == 0 {
                    set(phrase)
                    fading = false
                    direction = 1
                }
            }
        }
        
        if index == phrases.count - 1 {
            delay += Time.delta
            if delay >= 3.5 {
                button.text.color = float4(clamp(button.text.color.w + speed * Time.delta, min: 0, max: 1))
                button.text.text.display.refresh()
            }
        }
        
        opacity = clamp(opacity + speed * direction * Time.delta, min: 0, max: 1)
        text.color = float4(opacity)
        text.text.display.refresh()
    }
    
    func set(_ phrase: StoryPhrase) {
        if let bounds = phrase.bounds {
            text = Text(phrase.content, FontStyle("Lora-Regular", float4(1), 52.0), bounds)
        }else{
            text = Text(phrase.content, FontStyle("Lora-Regular", float4(1), 52.0))
        }
        text.location = float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y)
    }
    
    func render() {
        text.render()
    }
    
}

struct StoryPhrase {
    let time: Float
    let content: String
    var bounds: float2?
    
    init(_ time: Float, _ content: String, _ bounds: float2? = nil) {
        self.time = time
        self.content = content
        self.bounds = bounds
    }
}

