//
//  Cooldown.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/2/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class CooldownBehavior: TriggeredBehavior {
    var alive = true
    let limit: Float
    var cooldown: Float
    
    init(_ limit: Float) {
        self.limit = limit
        cooldown = 0
    }
    
    var available: Bool {
        return cooldown >= limit
    }
    
    func activate() {
        cooldown = 0
    }
    
    func update() {
        cooldown += Time.delta
    }
    
    func trigger() {
        
    }
}





















