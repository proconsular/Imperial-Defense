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
    
    static func process (command: Command, _ action: Command -> ()) {
        if case .NotPressed = command {
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
    
    var rect: RawRect
    var event: () -> ()
    var active = true
    
    init(_ location: float2, _ bounds: float2, _ event: () -> () = {}) {
        rect = RawRect(location, bounds)
        self.event = event
        super.init()
    }
    
    func use(command: Command) {
        guard active else { return }
        if case .Vector(let point) = command {
            if rect.contains(point) {
                pressed()
            }
        }
    }
    
    func pressed() {
        event()
    }
    
    override func display() {
        guard active else { return }
        super.display()
    }
    
}

class Button: InteractiveElement {
    
    var text: DynamicText?
    
    init(_ text: String, _ location: float2, _ event: () -> () = {}) {
        let loc = location - InterfaceElement.bounds("Button") / 2
        
        super.init(loc, float2(), event)
        
        if text != "" {
            self.text = DynamicText.defaultStyle(text, float4(0, 0, 0, 1), 128.0)
            self.text!.location = rect.location + rect.bounds / 2 - self.text!.frame / 2 + float2(0, 25)
        }
    }
    
    init(name: String, _ location: float2, _ event: () -> ()) {
        let loc = location - InterfaceElement.bounds(name) / 2
        super.init(loc, float2(), event)
    }
    
    override func display() {
        guard active else { return }
        super.display()
        text?.display()
    }
    
}

class TextButton: InteractiveElement {
    
    var text: DynamicText
    
    init(_ text: DynamicText, _ location: float2, _ event: () -> ()) {
        self.text = text
        super.init(location - text.frame / 2, text.frame, event)
        self.text.location = rect.location + rect.bounds / 2 - self.text.frame / 2 + float2(0, 25)
    }
    
    override func display() {
        guard active else { return }
        text.display()
    }
    
}

class ToggleButton: Button {
    
    var texts: [DynamicText] = []
    var index: Int = 0
    
    init(_ texts: [String], _ location: float2, _ event: () -> () = {}) {
        super.init("", location, event)
        
        for text in texts {
            let dt = DynamicText.defaultStyle(text, float4(0, 0, 0, 1), 128.0)
            dt.location = rect.location + rect.bounds / 2 - dt.frame / 2 + float2(0, 25)
            self.texts.append(dt)
        }
        
    }
    
    override func pressed() {
        index ++% texts.count
        super.pressed()
    }
    
    override func display() {
        guard active else { return }
        super.display()
        texts[index].display()
    }
    
}







