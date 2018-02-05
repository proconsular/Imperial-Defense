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
        rect = FixedRect(location + float2(0, GameScreen.size.y), bounds)
        self.event = event
        self.location = rect.location
    }
    
    func use(_ command: Command) {
        guard active else { return }
        if let vector = command.vector {
            if rect.contains(vector) {
                event()
                Audio.play("button-click", 0.5)
            }
        }
    }
    
    func update() {
        rect.location = location
    }
    
    func render() {}
    
}

class TextButton: InteractiveElement {
    var text: Text
    
    init(_ text: Text, _ location: float2, _ event: @escaping () -> ()) {
        self.text = text
        super.init(location , text.size, event)
        self.text.location = location
    }
    
    override func update() {
        text.location = location
    }
    
    override func render() {
        guard active else { return }
        text.render()
    }
}

class ToggleTextButton: TextButton {
    var activated = true
    
    init(_ text: Text, _ location: float2, _ event: @escaping (Bool) -> ()) {
        super.init(text, location, {})
        self.event = { [unowned self] in
            self.activated = !self.activated
            event(self.activated)
        }
    }
}

class Button: InteractiveElement {
    
    var display: Display!
    
    init(_ texture: GLTexture, _ location: float2, _ bounds: float2, _ event: @escaping () -> ()) {
        display = Display(Rect(Transform(location), bounds), texture)
        display.camera = false
        super.init(location, bounds, event)
    }
    
    override func render() {
        display.render()
    }
    
}

class BorderedButton: TextButton {
    var display: Display
    var padding: float2
    var shape: Rect
    
    init(_ text: Text, _ location: float2, _ padding: float2, _ texture: GLTexture, _ event: @escaping () -> ()) {
        shape = Rect(location, float2(32))
        display = Display(shape, texture)
        self.padding = padding
        super.init(text, location, event)
        rect.bounds = text.size + padding + float2(32)
    }
    
    override func render() {
        renderCorners()
        
        let width = (text.size.x + padding.x * 2)
        let wc = Int(width / 32)
        let dw = width - (Float(wc) * 32)
        
        let height = text.size.y + padding.y * 2
        let hc = Int(height / 32)
        let dh = height - (Float(hc) * 32)
        
        renderVerticalEdge(width, dw, wc)
        renderHorizontalEdge(height, dh, hc)
        renderFill(dw, dh, wc, hc)
        
        super.render()
    }
    
    func renderCorners() {
        display.coordinates = SheetLayout(0, 3, 3).coordinates
        display.transform.location = location + float2(-text.size.x / 2 - padding.x - 16, -text.size.y / 2 - padding.y - 16) + float2(0, -GameScreen.size.y)
        display.refresh()
        display.render()
        
        display.coordinates = SheetLayout(2, 3, 3).coordinates
        display.transform.location = location + float2(text.size.x / 2 + padding.x + 16, -text.size.y / 2 - padding.y - 16) + float2(0, -GameScreen.size.y)
        display.refresh()
        display.render()
        
        display.coordinates = SheetLayout(6, 3, 3).coordinates
        display.transform.location = location + float2(-text.size.x / 2 - padding.x - 16, text.size.y / 2 + padding.y + 16) + float2(0, -GameScreen.size.y)
        display.refresh()
        display.render()
        
        display.coordinates = SheetLayout(8, 3, 3).coordinates
        display.transform.location = location + float2(text.size.x / 2 + padding.x + 16, text.size.y / 2 + padding.y + 16) + float2(0, -GameScreen.size.y)
        display.refresh()
        display.render()
    }
    
    func renderVerticalEdge(_ width: Float, _ dw: Float, _ wc: Int) {
        for i in 0 ..< wc {
            display.coordinates = SheetLayout(1, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(i) * 32 + 16, -text.size.y / 2 - padding.y - 16) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            
            display.coordinates = SheetLayout(7, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(i) * 32 + 16, text.size.y / 2 + padding.y + 16) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
        }
        
        if dw > 0 {
            shape.setBounds(float2(dw, 32))
            let d = 32 - dw
            display.coordinates = SheetLayout(1, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x + 16 + Float(wc) * 32 - d / 2, -text.size.y / 2 - padding.y - 16) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            
            display.coordinates = SheetLayout(7, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x + 16 + Float(wc) * 32 - d / 2, text.size.y / 2 + padding.y + 16) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            shape.setBounds(float2(32))
        }
    }
    
    func renderHorizontalEdge(_ height: Float, _ dh: Float, _ hc: Int) {
        for i in 0 ..< hc {
            display.coordinates = SheetLayout(3, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x - 16, -text.size.y / 2 - padding.y + 16 + Float(i) * 32) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            
            display.coordinates = SheetLayout(5, 3, 3).coordinates
            display.transform.location = location + float2(text.size.x / 2 + padding.x + 16, -text.size.y / 2 - padding.y + 16 + Float(i) * 32) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
        }
        if dh > 0 {
            shape.setBounds(float2(32, dh))
            let d = 32 - dh
            display.coordinates = SheetLayout(3, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x - 16, -text.size.y / 2 + 16 - d / 2 - padding.y + Float(hc) * 32) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            
            display.coordinates = SheetLayout(5, 3, 3).coordinates
            display.transform.location = location + float2(text.size.x / 2 + padding.x + 16, -text.size.y / 2 + 16 - d / 2 - padding.y + Float(hc) * 32) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            shape.setBounds(float2(32))
        }
    }
    
    func renderFill(_ dw: Float, _ dh: Float, _ wc: Int, _ hc: Int) {
        for i in 0 ..< wc {
            for j in 0 ..< hc {
                display.coordinates = SheetLayout(4, 3, 3).coordinates
                display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(i) * 32 + 16, -text.size.y / 2 - padding.y + Float(j) * 32 + 16) + float2(0, -GameScreen.size.y)
                display.refresh()
                display.render()
            }
        }
        
        if dw > 0 {
            shape.setBounds(float2(dw, 32))
            let d = 32 - dw
            for j in 0 ..< hc {
                display.coordinates = SheetLayout(4, 3, 3).coordinates
                display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(wc) * 32 + 16 - d / 2, -text.size.y / 2 - padding.y + Float(j) * 32 + 16) + float2(0, -GameScreen.size.y)
                display.refresh()
                display.render()
            }
            shape.setBounds(float2(32))
        }
        
        if dh > 0 {
            shape.setBounds(float2(32, dh))
            let d = 32 - dh
            for i in 0 ..< wc {
                display.coordinates = SheetLayout(4, 3, 3).coordinates
                display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(i) * 32 + 16, -text.size.y / 2 - padding.y + Float(hc) * 32 + 16 - d / 2) + float2(0, -GameScreen.size.y)
                display.refresh()
                display.render()
            }
            shape.setBounds(float2(32))
        }
        
        if dw > 0 && dh > 0 {
            shape.setBounds(float2(dw, dh))
            let s = float2(32 - dw, 32 - dh)
            display.coordinates = SheetLayout(4, 3, 3).coordinates
            display.transform.location = location + float2(-text.size.x / 2 - padding.x + Float(wc) * 32 + 16 - s.x / 2, -text.size.y / 2 - padding.y + Float(hc) * 32 + 16 - s.y / 2) + float2(0, -GameScreen.size.y)
            display.refresh()
            display.render()
            shape.setBounds(float2(32))
        }
        
    }
    
}












