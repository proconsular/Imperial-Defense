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

public class UserInterface {
    
    enum ScreenName {
        case Menu, Title
    }
    
    static var screen: Screen!
    static var controller = MainController()
    
    static var screens: [ScreenName: Screen] = [:]
    
    static func setScreen(screen: Screen) {
        self.screen = screen
    }
    
    static func switchScreen(name: ScreenName) {
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

public class Screen: Interface {
    
    var layers: [DisplayLayer] = []
    
    func update() {
        layers.forEach{$0.update()}
    }
    
    func display() {
        layers.forEach{$0.display()}
    }
    
    func use(command: Command) {
        Trigger.process(command) { [unowned self] (command) in
            self.layers.reverse().forEach{$0.use(command)}
        }
    }
    
}

public class InterfaceLayer: DisplayLayer {
    
    var location = float2()
    var objects: [InterfaceElement] = []
    var active = true
    
    func setLocation(newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (amount: float2) {
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
    
    func use(command: Command) {
        guard active else { return }
        objects.map{$0 as? Interface}.forEach{$0?.use(command)}
    }
    
}

public class InterfaceElement {
    
    var location = float2()
    
    init() {
        
    }
    
    init(_ location: float2, _ name: String) {
        
    }
    
    static func bounds (name: String) -> float2 {
        return float2()
    }
    
    func setLocation (newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (amount: float2) {
        location += amount
    }
    
    func display() {
        
    }
    
}