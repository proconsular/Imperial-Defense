//
//  PlayerAwayCondition.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerAwayCondition: PowerCondition {
    unowned let transform: Transform
    let distance: Float
    
    init(_ transform: Transform, _ distance: Float) {
        self.transform = transform
        self.distance = distance
    }
    
    func isPassed() -> Bool {
        if let player = Player.player {
            let dx = player.transform.location.x - transform.location.x
            if fabsf(dx) > distance {
                return true
            }
        }
        return false
    }
}
