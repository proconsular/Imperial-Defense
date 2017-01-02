//
//  Controller.swift
//  Relaci
//
//  Created by Chris Luttio on 9/16/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

struct Command {
    var vector: float2?
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
}

protocol Controller {
    func apply (_ location: float2) -> Command?
}

protocol Interface: class {
    func use (_ command: Command)
}

class LimitedController: Controller {
    var controller: Controller
    var rect: FixedRect
    
    init(_ controller: Controller, _ rect: FixedRect) {
        self.controller = controller
        self.rect = rect
    }
    
    func apply(_ location: float2) -> Command? {
        guard rect.contains(location) else { return nil }
        return controller.apply(location)
    }
}

class Stack<T> {
    var contents: [T]
    
    init() {
        contents = []
    }
    
    func wipe() {
        contents.removeAll()
    }
    
    func push(_ item: T) {
        contents.append(item)
    }
    
    func pop() {
        contents.removeLast()
    }
    
    var peek: T? {
        return contents.last
    }
}

class MainController {
    var stack: Stack<Controller>
    
    init() {
        stack = Stack()
    }
    
    func getCommands() -> [Command] {
        var commands: [Command] = []
        
        for press in Interaction.presses where press.down {
            if let command = stack.peek?.apply(press.location) {
                commands.append(command)
            }
        }
        
        if commands.isEmpty {
            return [Command(-1)]
        }
        
        return commands
    }
    
    func push(_ controller: Controller) {
        stack.push(controller)
    }
    
    func reduce() {
        stack.pop()
    }
    
}

class ControllerLayer: Controller {
    
    var subcontrollers: [Controller]
    
    init () {
        subcontrollers = []
    }
    
    func apply (_ location: float2) -> Command? {
        for controller in subcontrollers {
            if let command = controller.apply(location) {
                return command
            }
        }
        return nil
    }
    
}

class GameControllerLayer: ControllerLayer {
    
    override init() {
        super.init()
        let movement = LimitedController(HorizontialMovementController(), FixedRect(float2(Camera.size.x / 4, Camera.size.y / 2), float2(Camera.size.x / 2, Camera.size.y)))
        
        
        let shoot1 = LimitedController(PointController(2), FixedRect(float2(Camera.size.x * 3 / 4, Camera.size.y * 5 / 8), float2(Camera.size.x / 2, Camera.size.y * 1 / 4)))
        
        let shoot2 = LimitedController(PointController(3), FixedRect(float2(Camera.size.x * 3 / 4, Camera.size.y * 2 / 8), float2(Camera.size.x / 2, Camera.size.y * 2 / 4)))
        
        
        let jump = LimitedController(PointController(1), FixedRect(float2(Camera.size.x * 3 / 4, Camera.size.y * 7 / 8), float2(Camera.size.x / 2, Camera.size.y * 1 / 4)))
        
        let interface = LimitedController(PointController(4), FixedRect(float2(Camera.size.x / 2, Camera.size.y / 20), float2(Camera.size.x, Camera.size.y / 10)))
        self.subcontrollers = [interface, movement, shoot1, shoot2, jump]
    }
    
}

class HorizontialMovementController: Controller {
    let range: Float = 15.0
    
    var previous = Float.zero, velocity = Float.zero
    var values: (min: Float, max: Float) = (0, 0)
    
    func apply (_ location: float2) -> Command? {
        velocity = location.x - previous
        
        check(&values.min, location, <, min)
        check(&values.max, location, >, max)
        
        guard velocity != 0 else { return nil }
        
        let magnitude = abs(velocity)
        let direction = velocity / magnitude
        
        var command = Command(0)
        command.vector = ((float2(min(magnitude * 10, 500) * direction, 0) * ((1.0 / Float(dt)) / 60)))
        return command
    }
    
    fileprivate func check (_ value: inout Float, _ location: float2, _ operation: (Float, Float) -> Bool, _ function: (Float, Float) -> Float) {
        value = function (velocity, value)
        if operation (value, 0) {
            if abs (value - velocity) >= range {
                reset(location)
            }
        }
    }
    
    fileprivate func reset (_ location: float2) {
        velocity = 0
        values = (0, 0)
        previous = location.x
    }
}

class PointController: Controller {
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    func apply (_ location: float2) -> Command? {
        var command = Command(id)
        command.vector = location
        return command
    }
    
}

