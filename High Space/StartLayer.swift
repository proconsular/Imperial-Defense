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
        
        wave = WaveDisplay(GameScreen.size / 2 + float2(0, -100), float2(800, 200))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let leg = GameData.info.wave + 1
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y), "Legio \(leg.roman) wants to battle. Will you accept?", FontStyle(defaultFont, float4(1), 36)))
        
        let offset = float2(0, 350) + float2(0, -GameScreen.size.y)
        
        layer.objects.append(TextButton(Text("Battle", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset, {
            UserInterface.space.pop()
            UserInterface.controller.reduce()
            if let princ = UserInterface.space.contents[0] as? PrincipalScreen {
                princ.game.physics.unhalt()
                princ.game.start()
            }
        }))
        
        layers.append(layer)
    }
    
    override func display() {
        super.display()
        wave.render()
    }
    
}

class EndPrompt: Screen {
    
    var plate: WaveDisplay
    var destroyed: Bool
    var counter: Float
    
    var map: Map
    var physics: Simulation
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        plate = WaveDisplay(GameScreen.size / 2 + float2(0, -100), float2(800, 200))
        
        destroyed = false
        counter = 1
        
        map = Map(Camera.size)
        physics = Simulation(map.grid)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let wave = GameData.info.wave + 1
        
        layer.objects.append(Text(GameScreen.size / 2 + float2(0, 100) + float2(0, -GameScreen.size.y), "Legio \(wave.roman) has been destroyed.", FontStyle(defaultFont, float4(1), 36)))
        
        let offset = float2(0, 350)
        
        layer.objects.append(TextButton(Text("Forge", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset + float2(-300, -GameScreen.size.y), {
            UserInterface.space.wipe()
            UserInterface.controller.reduce()
            UserInterface.push(StoreScreen())
        }))
        
        layer.objects.append(TextButton(Text("Play", FontStyle(defaultFont, float4(1), 64)), GameScreen.size / 2 + offset + float2(300, -GameScreen.size.y), {
            UserInterface.space.wipe()
            UserInterface.controller.reduce()
            UserInterface.push(PrincipalScreen())
        }))
        
        layers.append(layer)
    }
    
    override func update() {
        super.update()
        
        map.update()
        physics.simulate()
        
        if !destroyed {
            counter -= Time.delta
            if counter <= 0 {
                destroyed = true
                
                let audio = Audio("explosion1")
                audio.volume = 1
                audio.start()
                map.append(Explosion(plate.plate.transform.location, 5.m))
                for _ in 0 ..< 30 {
                    makeParts(plate.plate.transform.location)
                }
            }
        }
    }
    
    func makeParts(_ location: float2) {
        let width: Float = 800
        let height: Float = 200
        let spark = Particle(location + float2(random(-width / 2, width / 2), random(-height / 2, height / 2)), random(4, 9))
        let col = random(0.5, 0.75)
        spark.color = float4(col, col, col, 1)
        let velo: Float = 400
        spark.body.relativeGravity = 1
        spark.rate = 0.1
        spark.body.velocity = float2(random(-velo, velo) / 2, random(-velo, -velo / 2))
        map.append(spark)
    }
    
    override func display() {
        super.display()
        map.render()
        if !destroyed {
            plate.render()
        }
    }
    
}











