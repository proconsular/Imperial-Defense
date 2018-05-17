//
//  Sprint.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Sprint: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    
    var counter: Float = 0
    var march: MarchBehavior
    
    init(_ soldier: Soldier, _ length: Float) {
        self.soldier = soldier
        counter = length
        march = MarchBehavior(soldier, soldier.animator)
    }
    
    func update() {
        if soldier.sprinter || !soldier.canSprint {
            alive = false
            return
        }
        counter -= Time.delta
        march.update()
        soldier.trail.update()
        soldier.animator.set(1)
        if counter <= 0 || !ActorUtility.spaceInFront(soldier, float2(0.75.m, 0)) {
            alive = false
            soldier.animator.set(0)
        }
    }
}
