//
//  Splash.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/15/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Splash: Screen {
    
    let title: SplashTitle
    
    let sky: SplashSky
    let mountains: Display
    let castle: Display
    let castle_scene: Display
    let far_cliffs: Display
    
    let clouds: SplashClouds
    
    var save: SaveDisplay
    
    var map: Map
    var simulation: Simulation
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        map = Map(Camera.size * 1.5)
        Map.current = map
        simulation = Simulation(map.grid)
        
        Camera.current = Camera()
        
        sky = SplashSky()
        
        mountains = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash_Mountains"))
        castle = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash_Castle"))
        castle_scene = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash_Castle_Scene"))
        far_cliffs = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash_FarCliffs"))
        
        clouds = SplashClouds()
        
        save = SaveDisplay(float2(GameScreen.size.x * 0.66, GameScreen.size.y * 0.75 - 5))
        
        MusicSystem.instance.append(MusicEvent("Title_intro"))
        MusicSystem.instance.append(MusicEvent("Title_main", true))
        
        title = SplashTitle()
       
        map.append(save)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let smallstyle = FontStyle(defaultFont, float4(1, 1, 1, 1), 36)
        
        let margin: Float = 35
        
        let storiel = Text(float2(Camera.size.x / 2, margin) + float2(0, -GameScreen.size.y), "a storiel game", smallstyle)
        let copyright = Text(float2(Camera.size.x / 2, Camera.size.y - margin) + float2(0, -GameScreen.size.y), "Copyright © 2017 Storiel, LLC. All rights reserved.", smallstyle)
        
        layer.objects.append(storiel)
        layer.objects.append(copyright)
        layer.objects.append(TextButton(Text("Tap to Play", FontStyle(defaultFont, float4(1, 1, 1, 1), 72)), float2(Camera.size.x / 2, Camera.size.y / 2 + 50) + float2(0, -GameScreen.size.y)) {
            play("button-click")
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                if enableStory {
                    UserInterface.space.push(StoryScreen())
                }else{
                    UserInterface.space.push(PrincipalScreen())
                }
            }
        })
        
        layer.objects.append(BorderedButton(Text("Reset", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y), float2(0, -24), GLTexture("ButtonBorder")) { [weak self] in
            if self!.save.alive {
                self!.save.delete()
            }
        })
        
        layer.objects.append(TextButton(Text("settings", FontStyle(defaultFont, float4(1, 1, 1, 1), 36)), float2(Camera.size.x - 90, 35) + float2(0, -GameScreen.size.y)) {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Settings())
            }
        })
        
        if debugDisplay {
            layer.objects.append(TextButton(Text("levels", FontStyle(defaultFont, float4(1, 1, 1, 1), 36)), float2(90, 35) + float2(0, -GameScreen.size.y)) {
                UserInterface.fade {
                    UserInterface.space.wipe()
                    UserInterface.controller.reduce()
                    UserInterface.space.push(LevelScreen())
                }
            })
            
            let text = Text("Debug: \(debug ? "On" : "Off")", FontStyle(defaultFont, float4(1, 1, 1, 1), 36))
            let toggle = ToggleTextButton(text, float2(Camera.size.x - 500, 35) + float2(0, -GameScreen.size.y)) { (active) in
                debug = active
                text.setString("Debug: \(debug ? "On" : "Off")")
            }
            layer.objects.append(toggle)
            
            let text_story = Text("Story: \(enableStory ? "On" : "Off")", FontStyle(defaultFont, float4(1, 1, 1, 1), 36))
            let toggle_story = ToggleTextButton(text_story, float2(500, 35) + float2(0, -GameScreen.size.y)) { (active) in
                enableStory = active
                text_story.setString("Story: \(enableStory ? "On" : "Off")")
            }
            layer.objects.append(toggle_story)
        }
        
        layers.append(layer)
    }
    
    override func update() {
        super.update()
        
        //firer.update()
        
        map.update()
        simulation.simulate()
        
        clouds.update()
        
        sky.update()
        title.update()
    }
    
    override func display() {
        sky.render()
        far_cliffs.render()
        clouds.render()
        
        mountains.render()
        castle_scene.render()
        castle.render()
        
        layers.forEach{$0.display()}
        title.render()
        save.render()
    }
    
}

class ShootEvent: Event {
    
    var location, direction: float2
    var frames: [Int]
    
    init(_ location: float2, _ direction: float2, _ frames: [Int]) {
        self.location = location
        self.direction = direction
        self.frames = frames
    }
    
    func activate() {
        let bullet = Bullet(location, direction, Impact(0, 12.m), Casing(float2(0.5.m, 0.1.m), float4(0, 1, 0, 1), ""))
        Map.current.append(bullet)
        Audio.play("shoot2", 0.05)
    }
    
}






















