//
//  RapidFireBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RapidFireBehavior: CooldownBehavior {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ limit: Float) {
        self.soldier = soldier
        super.init(limit)
    }
    
    override var available: Bool {
        return super.available && ActorUtility.hasLineOfSight(soldier)
    }
    
    override func activate() {
        super.activate()
        soldier.behavior.push(TemporaryBehavior(FireBehavior(soldier, 0.1), 1))
    }
    
}
