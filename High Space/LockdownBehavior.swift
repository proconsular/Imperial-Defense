//
//  LockdownBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LockdownBehavior: CooldownBehavior {
    unowned let soldier: Soldier
    let duration: Float
    
    init(_ soldier: Soldier, _ duration: Float, _ limit: Float) {
        self.soldier = soldier
        self.duration = duration
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        soldier.stop(duration) { [unowned soldier, unowned self] in
            soldier.setImmunity(true, self.duration)
        }
    }
}
