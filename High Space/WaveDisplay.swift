//
//  WaveDisplay.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/2/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
        if wave >= 101 {
            string = "???"
        }
        text.setString(string)
        text.render()
    }
}
