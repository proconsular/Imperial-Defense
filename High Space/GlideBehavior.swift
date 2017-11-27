//
//  GlideBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/21/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GlideBehavior: Behavior {
    
    var alive: Bool = true
    unowned var entity: Entity
    var speed: Float
    
    init(_ entity: Entity, _ speed: Float) {
        self.entity = entity
        self.speed = speed
    }
    
    func update() {
        if ActorUtility.spaceInFront(entity, float2(0.75.m, 0)) {
            entity.body.location.y += speed * Time.delta
        }
    }
    
}
