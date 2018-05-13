//
//  Selection.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Selection {
    var buttons: [TextButton]
    var index: Int
    
    init(_ location: float2, _ spacing: Float, _ options: [String]) {
        buttons = []
        index = 0
        
        for i in 0 ..< options.count {
            let option = options[i]
            let button = TextButton(Text(option, FontStyle(defaultFont, float4(1), 76)), float2(Float(i) * spacing - spacing * Float(options.count) / 2 + spacing / 2, 0) + location, { [unowned self] in
                self.select(i)
            })
            buttons.append(button)
        }
    }
    
    func select(_ index: Int) {
        self.index = index
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            button.text.color = float4(index == i ? 1 : 0.5)
            button.text.text.display.refresh()
        }
    }
    
}
