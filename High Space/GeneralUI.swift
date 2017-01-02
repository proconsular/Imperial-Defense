//
//  GeneralUI.swift
//  Imperial Defence
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
    
    var rect: FixedRect
    var event: () -> ()
    var active = true
    
    init(_ location: float2, _ bounds: float2, _ event: @escaping () -> () = {}) {
        rect = FixedRect(location, bounds)
        self.event = event
        super.init(location)
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
    
    init(_ location: float2, _ event: @escaping () -> () = {}) {
        let loc = location
        
        super.init(loc, self.text!.bounds, event)
    }
    
    override func display() {
        guard active else { return }
        super.display()
        text?.render()
    }
    
}

class TextButton: InteractiveElement {
    
    var text: Text
    
    init(_ text: Text, _ location: float2, _ event: @escaping () -> ()) {
        self.text = text
        super.init(location, text.size, event)
        self.text.text.location = rect.location
    }
    
    override func display() {
        guard active else { return }
        text.render()
    }
    
}






