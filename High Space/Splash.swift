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
                let loc = float2(Camera.size.x, Camera.size.y / 2) + float2(0, -GameScreen.size.y)
                let bullet = Bullet(loc, normalize(self!.save.transform.location - loc), Impact(1, 16.m), Casing(float2(0.5.m, 0.1.m) * 1.75, float4(1, 0, 0, 1), "save"))
                bullet.body.mask = 0b11
                Map.current.append(bullet)
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

class SaveDisplay: Entity, Damagable {
    var reflective: Bool = false
    
    var top: Display
    var bottom: Display
    var legion: Text
    var points: Text
    
    var location: float2
    let save_bounds: float2
    
    var vel: Float
    var delta: Float
    var direction: Float
    
    init(_ location: float2) {
        self.location = location
        delta = 0
        vel = 0
        direction = 1
        save_bounds = float2(32, 16) * 10
        let top_loc = location - float2(0, save_bounds.y / 4)
        let bot_loc = location + float2(0, save_bounds.y / 4)
        top = Display(top_loc, save_bounds / 2, GLTexture("SaveFile"))
        top.coordinates = SheetLayout(0, 1, 2).coordinates
        bottom = Display(bot_loc, save_bounds / 2, GLTexture("SaveFile"))
        bottom.coordinates = SheetLayout(1, 1, 2).coordinates
        let style = FontStyle(defaultFont, float4(1, 1, 1, 1), 20)
        legion = Text(top_loc + float2(0, -GameScreen.size.y) + float2(0, 5), "0", style)
        points = Text(bot_loc + float2(0, -GameScreen.size.y) + float2(0, -20), "0", style)
        
        let rect = Rect(location + float2(0, -GameScreen.size.y), float2(16, 32) * 10)
        super.init(Rect(rect.transform, float2()), rect, Substance.getStandard(1))
        
        body.tag = "save"
        body.object = self
        body.mask = 0b10
        
        reaction = DamageReaction(self)
    }
    
    func damage(_ amount: Float) {
        alive = false
        let explosion = Explosion(transform.location, 2.m)
        explosion.rate = 0.6
        explosion.color = float4(1, 1, 1, 1)
        Map.current.append(explosion)
        let blast = BlastEffect(transform, float2(16, 32) * 10)
        blast.generate()
        let a = Audio("explosion1")
        a.volume = sound_volume
        a.pitch = random(0.9, 1.1)
        a.start()
        GameData.reset()
    }
    
    override func update() {
//        vel += 150 * direction * Time.delta
//        
//        delta += vel * Time.delta
//        vel *= 0.98
//        
//        if abs(vel) >= 75 {
//            direction = -direction
//        }
//        
//        let location = self.location + float2(0, delta)
//        
//        top.transform.location = location - float2(0, save_bounds.y / 4) + float2(0, -GameScreen.size.y)
//        legion.location = location - float2(0, save_bounds.y / 6) + float2(0, -GameScreen.size.y)
//        
//        top.refresh()
//        legion.text.display.refresh()
//        
//        bottom.transform.location = location + float2(0, save_bounds.y / 4) + float2(0, -GameScreen.size.y)
//        points.location = location + float2(0, save_bounds.y / 6) + float2(0, -GameScreen.size.y)
//        
//        bottom.refresh()
//        points.text.display.refresh()
//        
//        transform.location = location + float2(0, -GameScreen.size.y)
    }
    
    override func render() {
        if !alive { return }
        top.render()
        bottom.render()
        var st = "\((GameData.info.wave + 1).roman)"
        if GameData.info.wave >= 100 {
            st = "Lord Saal"
        }
        legion.setString(st)
        legion.render()
        points.setString("\(GameData.info.points)")
        points.render()
    }
    
}






















