//
//  UpgradeView.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class UpgradeView: InterfaceElement, Interface {
    
    var location: float2
    
    let background: Display
    var icon: Display?
    
    var text: Text!
    var button: InteractiveElement!
    
    var fade: Float = 1
    var fade_velo: Float = 0
    var fade_acc: Float = 0
    var direction: Float = -1
    
    var upgrade: Upgrade
    
    var selected: (Upgrade) -> ()
    
    init(_ location: float2, _ upgrade: Upgrade, _ callback: @escaping (Upgrade) -> ()) {
        self.location = location
        self.upgrade = upgrade
        self.selected = callback
        
        background = Display(Circle(Transform(location + float2(0, -GameScreen.size.y)), 135), GLTexture("white"))
        background.color = float4(133 / 255, 35 / 255, 38 / 255, 1)
        
        icon = Display(Rect(background.transform, float2(150)), GLTexture(upgrade.name.lowercased()))
        
        button = InteractiveElement(location + float2(0, -GameScreen.size.y), float2(300)) {
            self.buy()
        }
        
        text = Text("\(upgrade.name)", FontStyle(defaultFont, float4(1), 48))
        text.location = location + float2(0, 210) + float2(0, -GameScreen.size.y)
    }
    
    func buy() {
        let cost = self.upgrade.computeCost()
        if GameData.info.points >= cost && upgrade.range.amount < upgrade.range.limit {
            GameData.info.points -= cost
            self.upgrade.upgrade()
            selected(upgrade)
        }
        GameData.info.record(upgrader)
        GameData.persist()
    }
    
    func use(_ command: Command) {
        button.use(command)
    }
    
    func render() {
        
        fade_acc += 0.01 * direction * Time.delta
        fade_acc *= 0.9
        
        fade_velo += fade_acc
        fade_velo *= 0.95
        
//        fade_velo += 0.05 * direction * Time.delta
//        fade_velo *= 0.98
//        
        fade += fade_velo
        
        if fade < 0.5 {
            direction = 1
        }
        if fade > 0.9 {
            direction = -1
        }
        
        //background.color = float4(133 / 255, 35 / 255, 38 / 255, 1) * fade
       // background.refresh()
        background.render()
        icon?.render()
        text.setString("\(upgrade.name) \(Int(upgrade.range.amount).roman)".trimmed)
        text.render()
    }
    
}
