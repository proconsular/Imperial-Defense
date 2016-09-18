//
//  Screens.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/17/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

let backcorner = float2(175, Camera.size.y - 75)
let rightcorner = float2(Camera.size.x - 175, Camera.size.y - 75)


class TextElement: InterfaceElement {
    
    var text: DynamicText
    
    init(_ location: float2, _ text: DynamicText) {
        self.text = text
        self.text.location = location
        super.init()
        self.location = location
    }
    
    func setText(_ text: DynamicText) {
        self.text = text
        self.text.location = location
    }
    
    override func display() {
        text.render()
    }
    
}
