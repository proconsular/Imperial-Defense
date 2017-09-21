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
    var music: String = "7 Emprate"
    
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
            let display = StoryDisplay(GameData.info.wave - 1)
            story = display
            
            let quote = display.quotes[0]
            
            if quote.contains("empress") {
                music = "4 Empress"
            }else if quote.contains("legions") {
                music = "8 Legions"
            }else if quote.contains("princeps") {
                music = "9 Princeps"
            }
            
            if display.quotes.count == 1 {
                let complete = TextButton(Text("Another battle", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
                    UserInterface.fade {
                        UserInterface.space.wipe()
                        
                        UserInterface.controller.reduce()
                        UserInterface.space.push(PrincipalScreen())
                        
//                        GameData.info.wave += 1
//                        UserInterface.space.push(StoryScreen())
                    }
                }
                layer.objects.append(complete)
            }else{
                let complete = TextButton(Text("What else?", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
                    UserInterface.fade {
                        if display.index + 1 < display.quotes.count {
                            display.index += 1
                        }else{
                            UserInterface.space.wipe()
                            UserInterface.controller.reduce()
                            UserInterface.space.push(PrincipalScreen())
                        }
                    }
                }
                layer.objects.append(complete)
            }
            
        }
        
        layers.append(layer)
        
        
        
        let sound = Audio(music)
        sound.loop = true
        sound.start()
    }
    
    deinit {
        let sound = Audio(music)
        sound.stop()
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
    
    var quotes: [StoryQuote]
    var index: Int
    
    init(_ level: Int) {
        index = 0
        var story = "Unwritten Story Screen"
        if level < GameData.info.story.screens.count {
            story = GameData.info.story.screens[level]
        }
        quotes = []
        
        let qs = story.components(separatedBy: "~")
        
        for q in qs where q.trimmed != "" {
            quotes.append(StoryQuote(q))
        }
    }
    
    func update() {
        
    }
    
    func render() {
        quotes[index].render()
    }
    
}

class StoryQuote {
    
    var lines: [Text]
    
    convenience init(_ story: String) {
        self.init(story, float2(Camera.size.x / 2, Camera.size.y / 2) + float2(0, -GameScreen.size.y) + float2(0, -Camera.size.y * 0.05))
    }
    
    init(_ story: String, _ location: float2) {
        let style = FontStyle(defaultFont, float4(1), 52.0)
        lines = []
        var l = story.components(separatedBy: "\n")
        var quote = ""
        if let last = l.last {
            if last.hasPrefix("–") {
                quote = last
                l.removeLast()
            }
        }
        let spacing: Float = 65
        for n in 0 ..< l.count {
            let line = l[n]
            if line.trimmed == "" { continue }
            let text = Text(line, style)
            text.location = location + float2(0, Float(n) * spacing - Float(l.count) / 2 * spacing + spacing / 2)
            lines.append(text)
        }
        
        if quote != "" {
            let text = Text(quote, style)
            text.location = location + float2(0, spacing * 3)
            lines.append(text)
        }
    }
    
    func render() {
        for line in lines {
            line.render()
        }
    }
    
    func contains(_ word: String) -> Bool {
        for line in lines {
            if line.string.lowercased().contains(word) {
                return true
            }
        }
        return false
    }
    
}


















