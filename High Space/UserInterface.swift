//
//  UserInterface.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol DisplayLayer: Interface {
    func update()
    func display()
}

class UserInterface {
    
    static var controller = MainController()
    
    static var spaces: [ScreenSpace] = []
    static var index = 0
    
    static var space: ScreenSpace {
        return spaces[index]
    }
    
    static func create() {
        //controller.push(PointController(0))
    }
    
    static func update() {
        let commands = controller.getCommands()
        for command in commands {
            space.use(command)
        }
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
    
    static func push(_ screen: Screen) {
        space.push(screen)
    }
    
}


















