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
    var music: String = "Emprate"
    
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
            
            //let quote = display.quotes[0]
            
//            if quote.contains("empress") {
//                music = "4 Empress"
//            }else if quote.contains("legions") {
//                music = "8 Legions"
//            }else if quote.contains("princeps") {
//                music = "9 Princeps"
//            }
            
//            let sounds = AudioLibrary.shared().sounds!
//            
            
//            for sound in sounds.allKeys as! [String] {
//                if sound.contains(mus) {
//                    music = sound
//                    break
//                }
//            }
            
            let mus = "Scene\(GameData.info.wave)"
            var name = ""
            
            let docsPath = Bundle.main.resourcePath!
            let fileManager = FileManager.default
            
            do {
                let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath)
                for m in docsArray {
                    if m.contains(mus) {
                        name = m.components(separatedBy: ".")[0]
                        break
                    }
                }
            } catch {
                print(error)
            }
            
            music = name
            AudioLibrary.shared().loadAudio(name, 44100)
            
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
//                            GameData.info.wave += 1
//                            UserInterface.space.push(StoryScreen())
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
        
        AudioLibrary.shared().unloadMusic(withName: music)
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


















