//
//  ComplexBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ComplexBehavior: Behavior {
    var alive: Bool = true
    var behaviors: [Behavior]
    
    init() {
        behaviors = []
    }
    
    func update() {
        behaviors.forEach{
            $0.update()
        }
        behaviors = behaviors.filter{ $0.alive }
    }
    
    func append(_ behavior: Behavior) {
        behaviors.append(behavior)
    }
}
