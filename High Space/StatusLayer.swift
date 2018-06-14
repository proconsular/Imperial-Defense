//
//  StatusLayer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

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
        
        let sh = LifeDisplayAdapter(health.shield!, float4(109 / 255, 107 / 255, 255 / 255, 1))
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
