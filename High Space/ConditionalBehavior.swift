//
//  ConditionalBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ConditionalBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    let condition: () -> Bool
    let behavior: Behavior
    
    init(_ behavior: Behavior, _ condition: @escaping () -> Bool) {
        self.behavior = behavior
        self.condition = condition
    }
    
    func activate() {
        if condition() {
            active = true
        }
    }
    
    func update() {
        behavior.update()
        active = condition()
    }
}
