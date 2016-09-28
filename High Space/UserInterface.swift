//
//  UserInterface.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol DisplayLayer: Interface {
    func update()
    func display()
}

open class UserInterface {
    
    enum ScreenName {
        case menu, title
    }
    
    static var controller = MainController()
    
    static var spaces: [ScreenSpace] = []
    static var index = 0
    
    static var space: ScreenSpace {
        return spaces[index]
    }
    
    static func create() {
        controller.push(PointController(0))
    }
    
    static func update() {
        controller.getCommands().forEach(space.use)
        space.update()
    }
    
    static func display () {
        space.display()
    }
    
    static func set(index: Int) {
        self.index = index
    }
    
    static func set(space: ScreenSpace) {
        spaces.append(space)
        index = spaces.count - 1
    }
    
}

class ScreenSpace: Stack<Screen>, Interface {
    
    func use(_ command: Command) {
        peek?.use(command)
    }
    
    func update() {
        peek?.update()
    }
    
    func display() {
        peek?.display()
    }
    
}

open class Screen: Interface {
    var layers: [DisplayLayer] = []
    
    func update() {
        layers.forEach{$0.update()}
    }
    
    func display() {
        layers.forEach{$0.display()}
    }
    
    func use(_ command: Command) {
        Trigger.process(command) { [unowned self] (command) in
            self.layers.reversed().forEach{$0.use(command)}
        }
    }
}

open class InterfaceLayer: DisplayLayer {
    
    var location = float2()
    var objects: [InterfaceElement] = []
    var active = true
    
    func setLocation(_ newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (_ amount: float2) {
        for obj in objects {
            obj.move(amount)
        }
        location += amount
    }
    
    func update() {
        
    }
    
    func display() {
        guard active else { return }
        objects.forEach{$0.display()}
    }
    
    func use(_ command: Command) {
        guard active else { return }
        objects.map{$0 as? Interface}.forEach{$0?.use(command)}
    }
    
}

open class InterfaceElement {
    
    var location = float2()
    
    init(_ location: float2) {
        self.location = location
    }
    
    func setLocation (_ newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (_ amount: float2) {
        location += amount
    }
    
    func display() {
        
    }
    
}
