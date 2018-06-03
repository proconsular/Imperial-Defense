//
//  TextPlate.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 6/2/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
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
