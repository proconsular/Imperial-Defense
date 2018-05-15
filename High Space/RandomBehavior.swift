//
//  RandomBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RandomBehavior: ActiveBehavior {
    var alive: Bool = true
    
    var behaviors: [ActiveBehavior]
    var index: Int
    
    init(_ behaviors: [ActiveBehavior] = []) {
        index = 0
        self.behaviors = behaviors
    }
    
    var active: Bool {
        return behaviors[index].active
    }
    
    func activate() {
        let rand = 1 + Int(random(0, 3) >= 1 ? 0 : 1)
        index = (index + rand) % behaviors.count
        behaviors[index].activate()
    }
    
    func update() {
        behaviors[index].update()
    }
}
