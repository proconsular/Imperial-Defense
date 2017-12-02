//
//  PrincipalScreen.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PrincipalScreen: Screen {
    let game: Game
    var setter: GameSetter
    
    override init() {
        game = Game()
        
        setter = debug ? DebugSetter() : LevelSetter()
        setter.set(game)
        
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        layers.append(game)
        layers.append(StatusLayer())
    }
    
    deinit {
        UserInterface.controller.swipe()
    }
    
    override func use(_ command: Command) {
        layers.reversed().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
    }
    
}
