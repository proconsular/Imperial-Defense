//
//  ConsumeBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ConsumeBehavior: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    let drain: DrainEffect
    
    init(_ soldier: Soldier, _ target: Soldier) {
        self.soldier = soldier
        drain = DrainEffect(soldier)
        drain.target = target
    }
    
    func update() {
        drain.update()
    }
}
