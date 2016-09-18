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
    
    static var screen: Screen!
    static var controller = MainController()
    
    static var screens: [ScreenName: Screen] = [:]
    
    static func create() {
        controller.stack.push(PointController(0))
    }
    
    static func setScreen(_ screen: Screen) {
        self.screen = screen
    }
    
    static func switchScreen(_ name: ScreenName) {
        self.screen = screens[name]
    }
    
    static func update() {
        controller.getCommands().forEach(screen.use)
        screen.update()
    }
    
    static func display () {
        screen.display()
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
    
    func setLocation (_ newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (_ amount: float2) {
        location += amount
    }
    
    func display() {
        
    }
    
}
