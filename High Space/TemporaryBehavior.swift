//
//  TemporaryBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class TemporaryBehavior: Behavior {
    var alive: Bool = true
    var counter: Float
    var behavior: Behavior
    var onComplete: (() -> ())?
    
    init(_ behavior: Behavior, _ count: Float, _ onComplete: (() -> ())? = nil) {
        self.counter = count
        self.behavior = behavior
        self.onComplete = onComplete
    }
    
    func update() {
        behavior.update()
        counter -= Time.delta
        if counter <= 0 {
            alive = false
            onComplete?()
        }
    }
}
