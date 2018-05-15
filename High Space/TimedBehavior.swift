//
//  TimedBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class TimedBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    var timer, rate: Float
    let behavior: Behavior
    
    init(_ behavior: Behavior, _ rate: Float) {
        self.behavior = behavior
        self.rate = rate
        timer = 0
    }
    
    func activate() {
        active = true
        timer = 0
    }
    
    func update() {
        timer += Time.delta
        if timer >= rate {
            active = false
        }
        behavior.update()
    }
}
