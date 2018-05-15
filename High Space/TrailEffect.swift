//
//  TrailEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class TrailEffect {
    
    unowned let entity: Entity
    let rate: Float
    let decay: Float
    var counter: Float
    
    init(_ entity: Entity, _ rate: Float, _ decay: Float) {
        self.entity = entity
        self.rate = rate
        self.decay = decay
        counter = 0
    }
    
    func update() {
        counter += Time.delta
        if counter >= rate {
            counter = 0
            Map.current.append(GhostEffect(entity, decay))
        }
    }
    
}
