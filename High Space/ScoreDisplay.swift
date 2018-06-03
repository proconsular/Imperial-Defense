//
//  ScoreDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/2/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
