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
    let border: Display
    
    var text: Text!
    var button: InteractiveElement!
    
    var fade: Float = 1
    var fade_velo: Float = 0
    var fade_acc: Float = 0
    var direction: Float = -1
    
    var upgrade: Upgrade
    
    let slots: CrystalSlot
    
    var selected: (Upgrade) -> ()
    
    init(_ location: float2, _ upgrade: Upgrade, _ callback: @escaping (Upgrade) -> ()) {
        self.location = location
        self.upgrade = upgrade
        self.selected = callback
        
        let loc = location + float2(0, -GameScreen.size.y)
        
        let transform = Transform(loc)
        
        background = Display(Circle(transform, 135), GLTexture("white"))
        background.color = float4(133 / 255, 35 / 255, 38 / 255, 1)
        
        border = Display(Rect(loc, float2(360, 450)), GLTexture("UpgradeBorder"))
        
        icon = Display(Rect(background.transform, float2(275)), GLTexture("Upgrades"))
        
        var i = 0
        if upgrade.name.lowercased() == "shield" {
            i = 1
        }else if upgrade.name.lowercased() == "barrier" {
            i = 2
        }
        
        icon?.material.coordinates = SheetLayout(i, 3, 1).coordinates
        
        slots = CrystalSlot(location + float2(0, 190) + float2(0, -GameScreen.size.y), upgrade.computeCost())
        
        button = InteractiveElement(location + float2(0, -GameScreen.size.y), float2(300)) {
            self.buy()
        }
        
        text = Text("\(upgrade.title)", FontStyle("Augustus", float4(1), 24))
        text.location = location + float2(0, -190) + float2(0, -GameScreen.size.y)
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
        //background.render()
        
        if GameData.info.points < upgrade.computeCost() {
            icon!.color = float4(0.5, 0.5, 0.5, 1)
            icon?.refresh()
        }
        
        border.render()
        
        icon?.render()
        if upgrade.range.amount > 0 {
            text.setString("\(Int(upgrade.range.amount).roman)".trimmed)
            text.render()
        }
        slots.render()
    }
    
}
























