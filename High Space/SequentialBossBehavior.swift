//
//  SequentialBossBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SequentialBossBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var behaviors: [ActiveBehavior]
    var index: Int
    
    init() {
        behaviors = []
        index = 0
    }
    
    func activate() {
        index = 0
        active = true
        behaviors[index].activate()
    }
    
    func update() {
        if index < behaviors.count {
            let current = behaviors[index]
            current.update()
            if !current.active {
                index += 1
                if index < behaviors.count {
                    behaviors[index].activate()
                }
            }
        }else{
            active = false
        }
    }
}
