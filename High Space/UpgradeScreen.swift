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
        
        layer.objects.append(BorderedButton(Text("Escape", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset - spacing, float2(8, -16), GLTexture("ButtonBorder"), {
            UserInterface.fade {
                UserInterface.space.wipe()
                UserInterface.controller.reduce()
                UserInterface.space.push(Splash())
            }
        }))
        
        layer.objects.append(BorderedButton(Text("Defend", FontStyle(defaultFont, float4(1), 64)), Camera.size / 2 + offset + spacing, float2(8, -16), GLTexture("ButtonBorder"), {
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
        
        let music = Audio("Castle")
        music.loop = true
        music.start()
        
        for _ in 0 ..< 100 {
            energy.populate()
        }
    }
    
    deinit {
        let music = Audio("Castle")
        music.stop()
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

class EnergyStream {
    
    let location, bounds: float2
    
    init(_ location: float2, _ bounds: float2) {
        self.location = location
        self.bounds = bounds
    }
    
    func update() {
        for _ in 0 ..< 2 {
            generate()
        }
    }
    
    func generate() {
        let particle = Particle(location + float2(0, random(-bounds.y / 2, bounds.y / 2)), random(2, 5))
        
        particle.body.velocity = float2(random(-6.m, -8.m), 0)
        particle.rate = random(0.1, 0.5)
        
        Map.current.append(particle)
    }
    
    func populate() {
        let particle = Particle(location + float2(random(-Camera.size.x, 0), random(-bounds.y / 2, bounds.y / 2)), random(2, 5))
        
        particle.body.velocity = float2(random(-6.m, -8.m), 0)
        particle.rate = random(0.1, 0.5)
        
        Map.current.append(particle)
    }
    
}

class BuyEffect {
    
    let display: Display
    let animator: Animator
    var active: Bool = false
    
    let texture_animator: TextureAnimator
    
    init() {
        display = Display(Rect(float2(), float2(128 * 3)), GLTexture("Upgrade_Effects"))
        texture_animator = TextureAnimator(GLTexture("Upgrade_Effects").id, SheetLayout(0, 5, 2))
        texture_animator.append(SheetAnimator(0.025, [], SheetAnimation(0, 5, 5, 2)))
        animator = Animator(TimedAnimationPlayer(texture_animator))
    }
    
    func update() {
        animator.update()
        animator.apply(display.material)
    }
    
    func activate(_ location: float2) {
        display.transform.location = location + float2(0, -GameScreen.size.y)
        texture_animator.current.animation.index = 0
        active = true
    }
    
    func render() {
        if active {
            display.refresh()
            display.render()
        }
        if texture_animator.frame >= 4 {
            active = false
        }
    }
    
}

class Treasure {
    
    let display: Display
    let gem: Display
    let count: Text
    
    init(_ location: float2) {
        let size = float2(64) * 4
        display = Display(Rect(location, size), GLTexture("Treasure"))
        display.coordinates = SheetLayout(0, 1, 3).coordinates
        gem = Display(Rect(location + float2(-size.x * 0.1, -size.y * 0.33), float2(16) * 4), GLTexture("Crystal"))
        gem.coordinates = SheetLayout(0, 4, 1).coordinates
        let loc = location + float2(size.x * 0.1 , -size.y * 0.33)
        count = Text(loc, "0", FontStyle(defaultFont, float4(1), 32))
    }
    
    func update() {
        let points = GameData.info.points
        let index = clamp(2 - points / 4, min: 0, max: 2)
        display.coordinates = SheetLayout(index, 1, 3).coordinates
        display.refresh()
    }
    
    func render() {
        if GameData.info.points > 0 {
            display.render()
            gem.render()
            count.setString("\(GameData.info.points)")
            count.render()
        }
    }
    
}

class Anvil {
    
    let display: Display
    let animator: Animator
    var counter: Float
    
    init(_ location: float2) {
        display = Display(Rect(location, float2(32) * 7), GLTexture("Anvil"))
        display.coordinates = SheetLayout(0, 6, 2).coordinates
        let texture = TextureAnimator(GLTexture("Anvil").id, SheetLayout(0, 6, 2))
        texture.append(SheetAnimator(0.05, [AnvilEvent([2])], SheetAnimation(0, 6, 6, 1)))
        texture.append(SheetAnimator(0.2, [], SheetAnimation(6, 4, 6, 1)))
        animator = Animator(TimedAnimationPlayer(texture))
        animator.set(1)
        counter = 0
    }
    
    func work() {
        counter = 3
        animator.set(0)
    }
    
    func render() {
        counter -= Time.delta
        if counter < 0 && animator.player.animation.frame == 0 {
            animator.set(1)
        }
        animator.update()
        animator.apply(display.material)
        display.refresh()
        display.render()
    }
    
}

class AnvilEvent: Event {
    var frames: [Int]
    
    init(_ frames: [Int]) {
        self.frames = frames
    }
    
    func activate() {
        let thunder = Audio("forge-hit")
        thunder.pitch = random(0.9, 1.1)
        thunder.volume = sound_volume
        thunder.start()
    }
    
}















