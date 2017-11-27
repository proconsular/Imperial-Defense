//
//  StatusLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TextPlate {
    
    var plate: Display!
    var text: Text
    
    init(_ location: float2, _ bounds: float2) {
        plate = Display(location, float2(bounds.x, bounds.y * 76 / 40), GLTexture())
        text = Text(location + float2(bounds.x * 0.2, 0) + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 48.0 * (bounds.y / 100)))
    }
    
}

class ScoreDisplay {
    
    var plate: Display!
    var crystal: Display!
    var text: Text
    
    init(_ location: float2, _ bounds: float2) {
        plate = Display(location, float2(bounds.x, 76 * bounds.y / 40), GLTexture("Plates"))
        plate.coordinates = SheetLayout(0, 1, 2).coordinates
        let spacing = bounds.x * 0.2
        crystal = Display(location + float2(-spacing, 0), float2(64), GLTexture("Crystal"))
        crystal.coordinates = SheetLayout(0, 4, 1).coordinates
        text = Text(location + float2(spacing, 0) + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 48.0 * (bounds.y / 100)))
    }
    
    func render() {
        plate.render()
        crystal.render()
        text.setString("\(GameData.info.points)")
        text.render()
    }
    
}

class LegionDisplay {
    
    var plate: Display!
    var soldier: Display!
    var text: Text
   
    init(_ location: float2, _ bounds: float2) {
        plate = Display(location, float2(bounds.x, 76 * bounds.y / 40), GLTexture("Plates"))
        plate.coordinates = SheetLayout(0, 1, 2).coordinates
        let spacing = bounds.x * 0.2
        soldier = Display(location + float2(-spacing, 0), float2(64), GLTexture("Soldier4"))
        soldier.coordinates = SheetLayout(0, 12, 3).coordinates
        text = Text(location + float2(spacing, 0) + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 48.0 * (bounds.y / 100)))
    }
    
    func render() {
        plate.render()
        soldier.render()
        text.setString("\(0)")
        text.render()
    }
    
}

class WaveDisplay {
    
    var plate: Display!
    var text: Text
    var wave: Int
    
    init(_ location: float2, _ bounds: float2, _ wave: Int) {
        plate = Display(location, float2(bounds.x, 76 * bounds.y / 40), GLTexture("Plates"))
        plate.coordinates = SheetLayout(0, 1, 2).coordinates
        text = Text(location + float2(0, -GameScreen.size.y), "0", FontStyle(defaultFont, float4(1), 48.0 * (bounds.y / 100)))
        self.wave = wave
    }
    
    func render() {
        plate.render()
        var string = "Legio \(wave.roman)"
        if wave >= 51 {
            string = "Emperor"
        }
        text.setString(string)
        text.render()
    }
    
}

class StatusLayer: InterfaceLayer {
    let score: ScoreDisplay
    let wave: WaveDisplay
    let legion: LegionDisplay
    
    let shield: PercentDisplay
    let stamina: PercentDisplay
    let weapon: PercentDisplay
    
    let background: Display!
    
    override init() {
        let size: Float = 80
        
        let health = Player.player.health
        
        let sh = LifeDisplayAdapter(health.shield!, float4(48 / 255, 181 / 255, 206 / 255, 1))
        sh.warnings.append(ShieldLowPowerWarning(float4(1, 0, 0, 1), 0.125, 0.33))
        
        let shieldBlocks = Int(13 + 5 * upgrader.shieldpower.range.percent)
        shield = PercentDisplay(float2(100, size / 2) + float2(0, -GameScreen.size.y), size * 0.37, shieldBlocks, 1, sh)
        shield.frame.color = float4(0)
        
        let ld = LifeDisplayAdapter(health.stamina, float4(53 / 255, 215 / 255, 83 / 255, 1))
        ld.warnings.append(NoShieldPowerWarning(health.shield!, float4(1, 0, 0, 1), 0.075))
        stamina = PercentDisplay(float2(100, size / 2) + float2(0, -GameScreen.size.y), size * 0.37, shieldBlocks, 1, ld)
        
        let wd = PlayerWeaponDisplayAdapter(Player.player.weapon)
        wd.warnings.append(WeaponLowPowerWarning(float4(1, 1, 0, 1), 0.3, 0.33))
        let weaponBlocks = Int(13 + 5 * upgrader.firepower.range.percent)
        weapon = PercentDisplay(float2(GameScreen.size.x - 20, size / 2) + float2(0, -GameScreen.size.y), size * 0.375, weaponBlocks, -1, wd)
        
        score = ScoreDisplay(float2(GameScreen.size.x / 2 - 200, size / 2 - 2), float2(180, size / 2 + 4))
        wave = WaveDisplay(float2(GameScreen.size.x / 2, size / 2 - 2), float2(224, size / 2 + 4), GameData.info.wave + 1)
        legion = LegionDisplay(float2(GameScreen.size.x / 2 + 200, size / 2 - 2), float2(180, size / 2 + 4))
        
        background = Display(float2(GameScreen.size.x / 2, size / 2), float2(GameScreen.size.x, size), GLTexture("GameUIBack"))
        
        super.init()
        
        objects.append(Button(GLTexture("pause"), float2(50, size / 2) + float2(0, -GameScreen.size.y), float2(size / 2) * 0.8, {
            UserInterface.push(PauseScreen())
        }))
    }
    
    override func update() {
        shield.update()
        stamina.update()
        weapon.update()
    }
    
    override func display() {
        background.render()
        
        super.display()
        
        stamina.render()
        shield.render()
        
        score.render()
        wave.render()
        legion.render()
        
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
    
    let bounds: float2
    
    init(_ location: float2, _ height: Float, _ count: Int, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.alignment = alignment
        
        blocks = []
        
        let padding: Float = 10
        let spacing: Float = 6
        
        let s = height - padding
        let width = (s + spacing) * Float(count) + spacing
        
        for i in 0 ..< count {
            let loc = location + Float(alignment) * float2(Float(i) * (s + spacing) + s / 2 + padding / 2 + 1, 0)
            let size = float2(s)
            let b = Display(Rect(loc, size), GLTexture("white"))
            b.color = status.color
            //b.camera = false
            blocks.append(b)
        }
        
        bounds = float2(width, height)
        
        frame = Display(Rect(float2(), bounds), GLTexture("white"))
        frame.color = float4(0.1, 0.1, 0.1, 1)
        
        transform = frame.scheme.schemes[0].hull.transform
        transform.assign(Camera.current.transform)
        transform.location = location + float2(width / 2 * Float(alignment), 0)
    }
    
    func move(_ delta: float2) {
        transform.location += delta
        for block in blocks {
            block.transform.location += delta
        }
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
