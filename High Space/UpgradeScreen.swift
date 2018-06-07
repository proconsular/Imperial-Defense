//
//  StoreScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class StoreScreen: Screen {
    let background: Display
    let brick: Display
    let points: Text
    
    let anvil: Anvil
    let treasure: Treasure
    let energy: EnergyStream
    let simulation: Simulation
    
    var fade: Float = 1
    var direction: Float = 1
    
    let buy_effect: BuyEffect
    
    override init() {
        UserInterface.controller.push(PointController(0))
        
        Map.current = Map(Camera.size * 1.25)
        
        simulation = Simulation(Map.current.grid)
        
        background = Display(float2(GameScreen.size.x / 2, GameScreen.size.y / 2), GameScreen.size, GLTexture("Forge-Back"))
        brick = Display(float2(GameScreen.size.x / 2, GameScreen.size.y / 2), GameScreen.size, GLTexture("Forge-Brick"))
        
        points = Text(" ", defaultStyle)
        points.location = float2(Camera.size.x / 2, 60 - GameScreen.size.y)
        
        anvil = Anvil(float2(Camera.size.x / 3, Camera.size.y * 0.7125) + float2(0, -GameScreen.size.y))
        
        treasure = Treasure(float2(Camera.size.x * 0.33, Camera.size.y * 0.705) + float2(0, -GameScreen.size.y))
        
        energy = EnergyStream(float2(Camera.size.x, Camera.size.y * (0.705 - 1)), float2(0, 2.1.m))
        
        buy_effect = BuyEffect()
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let uspacing = float2(700, 500)
        
        layer.objects.append(UpgradeView(float2(GameScreen.size.x / 2 - uspacing.x / 2, GameScreen.size.y / 2 - uspacing.y / 2), upgrader.shieldpower)
        { [unowned self] in
            self.buy($0)
        })
        layer.objects.append(UpgradeView(float2(GameScreen.size.x / 2 + uspacing.x / 2, GameScreen.size.y / 2 - uspacing.y / 2), upgrader.barrier)
        { [unowned self] in
            self.buy($0)
        })
        
        let spacing = float2(600, 0)
        let offset = float2(0, 475 - GameScreen.size.y)
        
        layer.objects.append(BorderedButton(Text("Title", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, float2(8, -16), GLTexture("ButtonBorder"), {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layer.objects.append(BorderedButton(Text("Play", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset + spacing, float2(8, -16), GLTexture("ButtonBorder"), {
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
        
        MusicSystem.instance.flush()
        MusicSystem.instance.append(MusicEvent("Castle", true))
        
        for _ in 0 ..< 100 {
            energy.populate()
        }
    }
    
    func buy(_ upgrade: Upgrade) {
        let uspacing = float2(700, 500)
        
        if upgrade.name == "Shield" {
            buy_effect.activate(float2(GameScreen.size.x / 2 - uspacing.x / 2, GameScreen.size.y / 2 - uspacing.y / 2))
        }
        if upgrade.name == "Barrier" {
            buy_effect.activate(float2(GameScreen.size.x / 2 + uspacing.x / 2, GameScreen.size.y / 2 - uspacing.y / 2))
        }
        
        let audio = Audio("upgrade_buy")
        audio.volume = 0.25
        audio.start()
    }
    
    func generate() {
        let p = Particle(treasure.display.transform.location + float2(random(-0.1.m, 0.1.m), random(-0.1.m, 0.1.m)), random(2, 5))
        
        p.body.velocity = float2(random(-6.m, 2.m), random(-2.m, 0))
        let color = float4(1, 0, 1, 1)
        p.color = color
        p.material["color"] = color
        
        Map.current.append(p)
    }
    
    override func update() {
        energy.update()
        fade += 0.1 * direction * Time.delta
        if fade > 1 {
            direction = -1
        }
        if fade < 0.5 {
            direction = 1
        }
        brick.color = float4(fade, fade, fade, 1)
        brick.refresh()
        treasure.update()
        simulation.simulate()
        Map.current.update()
        buy_effect.update()
        ParticleSystem.current.update()
    }
    
    override func display() {
        background.render()
        brick.render()
        super.display()
        treasure.render()
        buy_effect.render()
        ParticleSystem.current.render()
    }
}
















