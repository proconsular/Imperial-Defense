//
//  LineOfSightCondition.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LineOfSightCondition: PowerCondition {
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func isPassed() -> Bool {
        return ActorUtility.hasLineOfSight(soldier)
    }
}
