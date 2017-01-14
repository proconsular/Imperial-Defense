//
//  GeneralUI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/17/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
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
    
    var location: float2
    var rect: FixedRect
    var event: () -> ()
    var active = true
    
    init(_ location: float2, _ bounds: float2, _ event: @escaping () -> () = {}) {
        rect = FixedRect(location, bounds)
        self.event = event
        self.location = location
    }
    
    func use(_ command: Command) {
        guard active else { return }
        if let vector = command.vector {
            if rect.contains(vector) {
                event()
            }
        }
    }
    
    func render() {}
    
}

class TextButton: InteractiveElement {
    
    var text: Text
    
    init(_ text: Text, _ location: float2, _ event: @escaping () -> ()) {
        self.text = text
        super.init(location, text.size, event)
        self.text.location = rect.location
    }
    
    override func render() {
        guard active else { return }
        text.render()
    }
    
}

class Button: InteractiveElement {
    
    var display: Display
    
    init(_ texture: GLTexture, _ location: float2, _ bounds: float2, _ event: @escaping () -> ()) {
        display = Display(Rect(Transform(location), bounds), texture)
        display.scheme.camera = false
        super.init(location, bounds, event)
    }
    
    override func render() {
        display.render()
    }
    
}






