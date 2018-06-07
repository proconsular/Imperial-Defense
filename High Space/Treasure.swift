//
//  Treasure.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/6/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
