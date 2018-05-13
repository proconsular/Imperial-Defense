//
//  MainController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
    
    func swipe() {
        stack.peel()
    }
}
