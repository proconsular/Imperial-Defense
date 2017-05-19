//
//  Splash.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/15/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Splash: Screen {
    
    let background: Display
    var save: SaveDisplay
    let audio: Audio
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(Camera.size / 2 + float2(0, -GameScreen.size.y), Camera.size), GLTexture("Splash"))
        save = SaveDisplay(float2(GameScreen.size.x / 4, GameScreen.size.y * 2.5 / 4))
        
        audio = Audio("0 Title")
        if !audio.playing {
            audio.loop = true
            audio.volume = 1
            audio.pitch = 1
            audio.start()
        }
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let smallstyle = FontStyle(defaultFont, float4(1, 1, 1, 1), 36)
        let titlestyle = FontStyle(defaultFont, float4(1, 1, 1, 1), 128.0)
        
        let margin: Float = 35
        
        let storiel = Text(float2(Camera.size.x / 2, margin) + float2(0, -GameScreen.size.y), "a storiel game", smallstyle)
        let copyright = Text(float2(Camera.size.x / 2, Camera.size.y - margin) + float2(0, -GameScreen.size.y), "Copyright © 2017 Storiel, LLC. All rights reserved.", smallstyle)
        let title = Text(float2(Camera.size.x / 2, Camera.size.y / 2 - 150) + float2(0, -GameScreen.size.y), "Imperial Defense", titlestyle)
        
        layer.objects.append(storiel)
        layer.objects.append(copyright)
        layer.objects.append(title)
        layer.objects.append(TextButton(Text("Tap to Play", FontStyle(defaultFont, float4(1, 1, 1, 1), 72)), float2(Camera.size.x / 2, Camera.size.y / 2 + 50) + float2(0, -GameScreen.size.y)) {
            UserInterface.space.wipe()
            UserInterface.controller.reduce()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Reset", FontStyle(defaultFont, float4(1, 1, 1, 1), 56)), float2(Camera.size.x / 2, Camera.size.y / 2 + 425) + float2(0, -GameScreen.size.y)) {
            GameData.info = GameInfo.Default
            GameData.persist()
        })
        
        layers.append(layer)
    }
    
    deinit {
        audio.stop()
    }
    
    override func update() {
        super.update()
        save.update()
    }
    
    override func display() {
        background.render()
        layers.forEach{$0.display()}
        save.render()
    }
    
}


class SaveDisplay {
    
    var top: Display
    var bottom: Display
    var legion: Text
    var points: Text
    
    var location: float2
    let bounds: float2
    
    var vel: Float
    var delta: Float
    var direction: Float
    
    init(_ location: float2) {
        self.location = location
        delta = 0
        vel = 0
        direction = 1
        bounds = float2(32, 16) * 10
        let top_loc = location - float2(0, bounds.y / 4)
        let bot_loc = location + float2(0, bounds.y / 4)
        top = Display(top_loc, bounds / 2, GLTexture("SaveFile"))
        top.coordinates = SheetLayout(0, 1, 2).coordinates
        bottom = Display(bot_loc, bounds / 2, GLTexture("SaveFile"))
        bottom.coordinates = SheetLayout(1, 1, 2).coordinates
        let style = FontStyle(defaultFont, float4(1, 1, 1, 1), 20)
        legion = Text(top_loc + float2(0, -GameScreen.size.y), "0", style)
        points = Text(bot_loc + float2(0, -GameScreen.size.y), "0", style)
    }
    
    func update() {
        
        vel += 150 * direction * Time.delta
        
        delta += vel * Time.delta
        vel *= 0.98
        
        if abs(vel) >= 75 {
            direction = -direction
        }
        
        let location = self.location + float2(0, delta)
        
        top.transform.location = location - float2(0, bounds.y / 4) + float2(0, -GameScreen.size.y)
        legion.location = location - float2(0, bounds.y / 6) + float2(0, -GameScreen.size.y)
        
        top.refresh()
        legion.text.display.refresh()
        
        bottom.transform.location = location + float2(0, bounds.y / 4) + float2(0, -GameScreen.size.y)
        points.location = location + float2(0, bounds.y / 6) + float2(0, -GameScreen.size.y)
        
        bottom.refresh()
        points.text.display.refresh()
    }
    
    func render() {
        top.render()
        bottom.render()
        legion.setString("Legio \((GameData.info.wave + 1).roman)")
        legion.render()
        points.setString("\(GameData.info.points)")
        points.render()
    }
    
}






















