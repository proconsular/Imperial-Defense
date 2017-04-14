//
//  StatusLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ScoreDisplay {
    
    var plate: Display
    var crystal: Display
    var text: Text
    
    init(_ location: float2, _ bounds: float2) {
        plate = Display(location, bounds, GLTexture())
        plate.color = float4(0.1, 0.1, 0.1, 1)
        let spacing = bounds.x * 0.25
        crystal = Display(location + float2(-spacing, 0), float2(64), GLTexture("Crystal"))
        let anim = TextureAnimator(1, 4, 1, float2(1))
        crystal.coordinates = anim.coordinates
        text = Text(location + float2(spacing, 0) + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 72.0 * (bounds.y / 100)))
    }
    
    func render() {
        plate.render()
        crystal.render()
        text.setString("\(GameData.info.points)")
        text.render()
    }
    
}


class WaveDisplay {
    
    var plate: Display
    var text: Text
    
    init(_ location: float2, _ bounds: float2) {
        plate = Display(location, bounds, GLTexture())
        plate.color = float4(0.1, 0.1, 0.1, 1)
        text = Text(location + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 72.0 * (bounds.y / 100)))
    }
    
    func render() {
        plate.render()
        let wave = GameData.info.wave + 1
        text.setString("Legion \(wave.roman)")
        text.render()
    }
    
}

class StatusLayer: InterfaceLayer {
    let score: ScoreDisplay
    let wave: WaveDisplay
    
    let shield: PercentDisplay
    let stamina: PercentDisplay
    let weapon: PercentDisplay
    
    let background: Display
    
    let game: Game
    
    init(_ game: Game) {
        self.game = game
        let size: Float = 80
        
        let sh = LifeDisplayAdapter(game.player.health.shield!, float4(0, 0.65, 1, 1))
        sh.warnings.append(ShieldLowPowerWarning(float4(1, 0, 0, 1), 0.125, 0.33))
        shield = PercentDisplay(float2(115, size / 2) + float2(0, -GameScreen.size.y), size * 0.375, 18, 1, sh)
        shield.frame.color = float4(0)
        
        stamina = PercentDisplay(float2(115, size / 2) + float2(0, -GameScreen.size.y), size * 0.375, 18, 1, LifeDisplayAdapter(game.player.health.stamina, float4(0, 1, 0.65, 1)))
        weapon = PercentDisplay(float2(GameScreen.size.x - 30, size / 2) + float2(0, -GameScreen.size.y), size * 0.375, 14, -1, PlayerWeaponDisplayAdapter(game.player.weapon))
        
//        wave = Text(float2(300, 100) + float2(0, -GameScreen.size.y), " ", FontStyle(defaultFont, float4(1), 48.0))
//        points = Text(float2(GameScreen.size.x / 2, 5 + size / 2) + float2(0, -GameScreen.size.y), " ", FontStyle(defaultFont, float4(1), 72.0 * (size / 100) * 0.8))
//        
        
        score = ScoreDisplay(float2(GameScreen.size.x / 2 - 200, size / 2), float2(114, size / 2))
        wave = WaveDisplay(float2(GameScreen.size.x / 2 + 200, size / 2), float2(184, size / 2))
        
        background = Display(float2(GameScreen.size.x / 2, size / 2) , float2(GameScreen.size.x, size), GLTexture("GameUIBack"))
        //background.camera = false
        
        super.init()
        
        objects.append(Button(GLTexture("pause"), float2(50, size / 2) + float2(0, -GameScreen.size.y), float2(size / 2) * 0.8, {
            UserInterface.push(PauseScreen())
        }))
    }
    
    override func update() {
        shield.update()
        weapon.update()
    }
    
    override func display() {
        background.render()
        
        super.display()
        
        stamina.render()
        shield.render()
        
//        points.setString("\(Coordinator.wave) : \(GameData.info.points)")
//        points.render()
//        
        
        score.render()
        wave.render()
        
        weapon.render()
    }
}

protocol StatusItem {
    var percent: Float { get }
    var color: float4 { get }
    func update()
}

class PercentDisplay {
    
    let status: StatusItem
    
    let transform: Transform
    let frame: Display
    let alignment: Int
    
    var blocks: [Display]
    
    init(_ location: float2, _ height: Float, _ count: Int, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.alignment = alignment
        
        blocks = []
        
        let padding: Float = 10
        let spacing: Float = 6
        
        let s = height - padding
        let width = (s + spacing) * Float(count) + spacing
        
        for i in 0 ..< count {
            let loc = location + Float(alignment) * float2(Float(i) * (s + spacing) + s / 2 + padding / 2, 0)
            let size = float2(s)
            let b = Display(Rect(loc, size), GLTexture("white"))
            b.color = status.color
            //b.camera = false
            blocks.append(b)
        }
        
        frame = Display(Rect(float2(), float2(width, height)), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 1)
        
        transform = frame.scheme.schemes[0].hull.transform
        transform.assign(Camera.current.transform)
        transform.location = location + float2(width / 2 * Float(alignment), 0)
    }
    
    func update() {
        status.update()
    }
    
    func render() {
        frame.render()
        let visible = clamp(Int(Float(blocks.count) * status.percent), min: 0, max: blocks.count)
        for i in 0 ..< visible {
            blocks[i].color = status.color
            blocks[i].visual.refresh()
            blocks[i].render()
        }
    }
    
}
