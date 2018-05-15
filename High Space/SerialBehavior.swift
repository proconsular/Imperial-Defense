//
//  SerialBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SerialBehavior: Behavior {
    var alive: Bool = true
    var stack: Stack<Behavior>
    
    init() {
        stack = Stack<Behavior>()
    }
    
    func update() {
        let active = stack.peek!
        active.update()
        if !active.alive {
            stack.pop()
        }
    }
    
    var behavior: Behavior {
        return stack.peek!
    }
}
