//
//  LegionDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/2/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
        
        var count = 0
        for unit in Map.current.actorate.actors {
            if unit is Soldier {
                count += 1
            }
        }
        
        text.setString("\(count)")
        text.render()
    }
}
