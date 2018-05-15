//
//  SequentialBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SequencialBehavior<T: Behavior>: Behavior {
    var alive: Bool = true
    var behaviors: [T]
    var index: Int
    
    init() {
        behaviors = []
        index = 0
    }
    
    func update() {
        behaviors[index].update()
    }
}
