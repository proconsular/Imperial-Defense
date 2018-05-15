//
//  BossBehaviors.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BossBehavior: Behavior {
    var alive: Bool = true
    var behaviors: [ActiveBehavior]
    var index: Int
    
    init() {
        behaviors = []
        index = 0
    }
    
    func update() {
        let current = behaviors[index]
        if current.active {
            current.update()
        }
        if !behaviors[index].active {
            replace()
        }
    }
    
    func replace() {
        index = (index + 1) % behaviors.count
        behaviors[index].activate()
    }
    
    func append(_ behavior: ActiveBehavior) {
        behaviors.append(behavior)
    }
}



















