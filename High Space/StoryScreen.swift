//
//  StoryScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoryScreen: Screen {
    var background: Display!
    var story: StoryElement!
    
    override init() {
        super.init()
        setup()
        loadStory()
    }
    
    init(_ story: StoryElement) {
        super.init()
        setup()
        self.story = story
    }
    
    init(_ outro: StoryOutro) {
        super.init()
        setup()
        self.story = outro
        let layer = InterfaceLayer()
        layer.objects.append(outro.button)
        layers.append(layer)
    }
    
    func setup() {
        UserInterface.controller.push(PointController(0))
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y), Camera.size), GLTexture("white"))
        background.color = float4(0.01, 0.01, 0.01, 1)
    }
    
    func loadStory() {
        let layer = InterfaceLayer()
        
        if GameData.info.wave == 0 {
            let intro = StoryIntro()
            story = intro
            layer.objects.append(intro.button)
        }else{
            story = StoryDisplay(GameData.info.wave - 1)
            
            let complete = TextButton(Text("Another battle", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
                UserInterface.fade {
                    UserInterface.space.wipe()
                    UserInterface.controller.reduce()
                    UserInterface.space.push(PrincipalScreen())
                }
            }
            layer.objects.append(complete)
        }
        
        layers.append(layer)
    }
    
    override func update() {
        super.update()
        story.update()
    }
    
    override func display() {
        background.render()
        super.display()
        story.render()
    }
    
}

protocol StoryElement {
    func update()
    func render()
}

class StoryDisplay: StoryElement {
    
    let text: Text
    
    init(_ level: Int) {
        var story = "Unwritten Story Screen"
        if level < GameData.info.story.screens.count {
            story = GameData.info.story.screens[level]
        }
        text = Text(story, FontStyle("Lora-Regular", float4(1), 52.0), float2(400, 100))
        text.location = float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y)
    }
    
    func update() {
        
    }
    
    func render() {
        text.render()
    }
    
}


















