//
//  SoldierBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SoldierBehavior {
    var main: SerialBehavior
    var base: ComplexBehavior
    
    init() {
        main = SerialBehavior()
        base = ComplexBehavior()
        main.stack.push(base)
    }
    
    func update() {
        main.update()
    }
    
    func push(_ behavior: Behavior) {
        main.stack.push(behavior)
    }
}

















