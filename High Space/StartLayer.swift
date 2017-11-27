//
//  StartLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/16/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StartPrompt: Screen {
    
    var wave: WaveDisplay
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        wave = WaveDisplay(GameScreen.size / 2 + float2(0, -100), float2(800, 200), GameData.info.wave + 1)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let offset = float2(0, 0) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Battle", FontStyle(defaultFont, float4(1), 72)), GameScreen.size / 2 + offset, {
            UserInterface.space.pop()
            UserInterface.controller.reduce()
            if let princ = UserInterface.space.contents[0] as? PrincipalScreen {
                princ.game.level.simulation.unhalt()
                //princ.game.start()
            }
        }))
        
        layers.append(layer)
    }
    
    override func display() {
        super.display()
    }
    
}

class EndPrompt: Screen {
    
    let background: Display
    var opacity: Float = 0
    
    var plate: WaveDisplay
    var destroyed: Bool
    var counter: Float
    
    var map: Map
    var physics: Simulation
    
    var victory: Text
    
    let quote: StoryQuote
    
    var notifier: ShinyNotifier!
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture())
        background.camera = false
        background.color = float4(0, 0, 0, 1)
        
        let wave = GameData.info.wave + 1
        
        plate = WaveDisplay(GameScreen.size / 2 + float2(0, -300), float2(800, 200), wave)
        
        destroyed = false
        counter = 1
        
        map = Map(Camera.size)
        physics = Simulation(map.grid)
        
        victory = Text(GameScreen.size / 2 + float2(0, -GameScreen.size.y) + float2(0, -200), "VICTORUM OPTIMUM",  FontStyle("Augustus", float4(1), 144))
        
        quote = StoryQuote("You have obtained optimal victory.\nLegion \(wave.roman) lays in ruins.", GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y))
        
        
        super.init()
        
        let layer = InterfaceLayer()
        
//        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 50) + float2(0, -GameScreen.size.y), "Legio \(wave.roman) has been destroyed.", FontStyle("Augustus", float4(1), 48)))
        
//        layer.objects.append(Text(GameScreen.size / 2 + float2(0, -50) + float2(0, -GameScreen.size.y), "Legio \(wave.roman)", FontStyle(defaultFont, float4(1), 72)))
//        layer.objects.append(Text(GameScreen.size / 2 + float2(200, -100) + float2(0, -GameScreen.size.y), "Crystal \(GameData.info.points)", FontStyle(defaultFont, float4(1), 72)))
        
        let spacing = float2(500, 0)
        let offset = float2(0, 450) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Improve", FontStyle("Augustus", float4(1), 64)), GameScreen.size / 2 + offset - spacing, {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.push(StoreScreen())
            }
        }))
        
        notifier = ShinyNotifier(GameScreen.size / 2 + offset - spacing + float2(220, -5))
        
        layer.objects.append(TextButton(Text("Defend", FontStyle("Augustus", float4(1), 64)), GameScreen.size / 2 + offset + spacing, {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                if enableStory {
                    UserInterface.space.push(StoryScreen())
                }else{
                    UserInterface.space.push(PrincipalScreen())
                }
            }
        }))
        
        layers.append(layer)
        
        let audio = Audio("Victory")
        audio.loop = true
        audio.start()
    }
    
    deinit {
        let audio = Audio("Victory")
        audio.stop()
    }
    
    override func display() {
        background.render()
        super.display()
        victory.render()
        quote.render()
        
        if computeAvailableUpgrades() > 0 {
            notifier.set("\(computeAvailableUpgrades())")
            notifier.render()
        }
        
    }
    
    func computeAvailableUpgrades() -> Int {
        var amount = 0
        let points = GameData.info.points
        
        let b_m = upgrader.barrier.range.limit - upgrader.barrier.range.amount
        let s_m = upgrader.shieldpower.range.limit - upgrader.shieldpower.range.amount
        
        let m = b_m + s_m
        
        let c = points / 4
        
        amount += clamp(c, min: 0, max: Int(m))
        
        let p_m = upgrader.firepower.range.limit - upgrader.firepower.range.amount
        
        if m == 0 {
            amount += clamp(points / 8, min: 0, max: Int(p_m))
        }
        
        return amount
    }
    
}

class ShinyNotifier {
    let text: Text
    let display: Display
    var counter: Float = 0
    
    init(_ location: float2) {
        display = Display(Circle(Transform(location), 35), GLTexture())
        display.material["color"] = float4(1, 0, 0, 1)
        display.color = float4(1, 0, 0, 1)
        display.refresh()
        text = Text(location, "0", FontStyle(defaultFont, float4(1), 52))
        text.color = float4(0, 0, 0, 1)
    }
    
    func set(_ text: String) {
        self.text.setString(text)
    }
    
    func render() {
        counter += Time.delta
        if counter >= 0.1 {
            counter = 0
            if display.color.y == 0 {
                display.color = float4(1, 0.5, 0.5, 1)
            }else{
                display.color = float4(1, 0, 0, 1)
            }
            display.refresh()
        }
        display.render()
        text.render()
    }
    
}











