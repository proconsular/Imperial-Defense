//
//  Controller.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2014 FishyTale Digital, Inc. All rights reserved.
//

enum Command {
    case Vector(float2), Action(() -> ()), Pressed, NotPressed, Consumed, wasPressed
    
    mutating func consume() {
        self = .Consumed
    }
}

protocol Controller {
    func apply (press: Interaction) -> Command?
}

protocol Interface: class {
    func use (command: Command)
}

class LimitedController: Controller {
    var controller: Controller
    var rect: RawRect
    
    init(_ controller: Controller, _ rect: RawRect) {
        self.controller = controller
        self.rect = rect
    }
    
    func apply(press: Interaction) -> Command? {
        guard rect.contains(press.location) else { return nil }
        return controller.apply(press)
    }
}

class MainController: Controller {
    
    var subcontrollers: [Controller]
    
    init () {
        let first = LimitedController(HorizontialMovementController(), RawRect(float2(), float2(Camera.size.x / 2, Camera.size.y)))
        let second = LimitedController(PointController(), RawRect(float2(Camera.size.x / 2, 0), float2(Camera.size.x / 2, Camera.size.y)))
        self.subcontrollers = [first, second]
    }
    
    func getCommands() -> [Command] {
        var commands: [Command] = []
        
        for press in Interaction.presses where press.down {
            if let command = apply(press) {
                commands.append(command)
            }
        }
        
        if commands.isEmpty {
            commands.append(.NotPressed)
        }
        
        return commands
    }
    
    func apply (press: Interaction) -> Command? {
        for controller in subcontrollers {
            if let command = controller.apply(press) {
                return command
            }
        }
        return nil
    }
    
}

class HorizontialMovementController: Controller {
    
    let range: Float = 15.0
    
    var previous = Float.zero, velocity = Float.zero
    var values: (min: Float, max: Float) = (0, 0)
    var wasPressed: Bool = false
    
    func apply (press: Interaction) -> Command? {
        defer { wasPressed = press.down }
        guard press.down else { reset(press); return nil }
        
        if !wasPressed { previous = press.location.x }
        velocity = press.location.x - previous
        
        check(&values.min, press, <, min)
        check(&values.max, press, >, max)
        
        guard velocity != 0 else { return nil }
        
        let magnitude: Float = abs(velocity)
        let direction: Float = velocity / magnitude
        
        return .Vector(float2 (min (magnitude * 10, 500) * direction, 0) * ((1.0 / Float(dt)) / 60))
    }
    
    private func reset (touch: Interaction) {
        velocity = 0
        values = (0, 0)
        previous = touch.location.x
    }
    
    private func check (inout value: Float, _ touch: Interaction, _ operation: (Float, Float) -> Bool, _ function: (Float, Float) -> Float) {
        value = function (velocity, value)
        if operation (value, 0) {
            if abs (value - velocity) >= range {
                reset(touch)
            }
            
        }
    }
    
}

class PointController: Controller {
    
    func apply (press: Interaction) -> Command? {
        return .Pressed
    }
    
}

class ActivationController: Controller {
    
    func apply(press: Interaction) -> Command? {
        return .Action({})
    }
    
}
