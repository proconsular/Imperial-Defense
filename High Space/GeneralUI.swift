//
//  GeneralUI.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/17/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Trigger {
    
    static var pressed = false
    static var wasPressed = false
    
    static func process (_ command: Command, _ action: (Command) -> ()) {
        if command.id == -1 {
            pressed = false
        }else{
            pressed = true
        }
        if pressed && !wasPressed {
            action(command)
        }
        wasPressed = pressed
    }
    
}

class InteractiveElement: InterfaceElement, Interface {
    
    var rect: FixedRect
    var event: () -> ()
    var active = true
    
    init(_ location: float2, _ bounds: float2, _ event: @escaping () -> () = {}) {
        rect = FixedRect(location, bounds)
        self.event = event
        super.init()
    }
    
    func use(_ command: Command) {
        guard active else { return }
        if let vector = command.vector {
            if rect.contains(vector) {
                event()
            }
        }
    }
    
    override func display() {
        guard active else { return }
        super.display()
    }
    
}

class Button: InteractiveElement {
    
    var text: DynamicText?
    
    init(_ text: String, _ location: float2, _ event: @escaping () -> () = {}) {
        let loc = location
        
        if text != "" {
            self.text = DynamicText.defaultStyle(text, float4(0, 0, 0, 1), 128.0)
            self.text!.location = location
        }
        
        super.init(loc, self.text!.bounds, event)
    }
    
    init(name: String, _ location: float2, _ event: @escaping () -> ()) {
        let loc = location
        super.init(loc, float2(), event)
    }
    
    override func display() {
        guard active else { return }
        super.display()
        text?.render()
    }
    
}

class TextButton: InteractiveElement {
    
    var text: DynamicText
    
    init(_ text: DynamicText, _ location: float2, _ event: @escaping () -> ()) {
        self.text = text
        super.init(location, text.frame, event)
        self.text.location = rect.location
    }
    
    override func display() {
        guard active else { return }
        text.render()
    }
    
}

class ToggleButton: Button {
    
    var texts: [DynamicText] = []
    var index: Int = 0
    
    init(_ texts: [String], _ location: float2, _ event: @escaping () -> () = {}) {
        super.init("", location, event)
        
        for text in texts {
            let dt = DynamicText.defaultStyle(text, float4(0, 0, 0, 1), 128.0)
            dt.location = rect.location + rect.bounds / 2 - dt.frame / 2 + float2(0, 25)
            self.texts.append(dt)
        }
        
    }
    
    override func display() {
        guard active else { return }
        super.display()
        texts[index].render()
    }
    
}







