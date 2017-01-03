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
    
    let upgrade: Upgrade
    
    let background: Display
    var icon: Display?
    
    var text: Text!
    var button: InteractiveElement!
    
    init(_ location: float2, _ upgrade: Upgrade) {
        self.location = location
        self.upgrade = upgrade
        
        background = Display(Circle(Transform(location + float2(0, -Camera.size.y)), 135), GLTexture("white"))
        background.color = float4(0.2, 0.4, 0.3, 1)
        
        icon = Display(Rect(background.transform, float2(150)), GLTexture(upgrade.name.lowercased()))
        
        button = InteractiveElement(location, float2(300)) {
            self.buy()
        }
        
        text = Text("upgrade: amount", FontStyle(defaultFont, float4(1), 48))
        text.location = location + float2(0, 175)
    }
    
    func buy() {
        let cost = self.upgrade.computeCost()
        if Data.info.points >= cost {
            Data.info.points -= cost
            self.upgrade.upgrade()
        }
        Data.persist()
    }
    
    func use(_ command: Command) {
        button.use(command)
    }
    
    func render() {
        background.render()
        icon?.render()
        text.setString("\(upgrade.name): (\(upgrade.computeCost()))")
        text.render()
    }
    
}
