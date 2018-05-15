//
//  MarchBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MarchBehavior: Behavior {
    var alive: Bool = true
    unowned let entity: Entity
    var animator: Animator
    
    init(_ entity: Entity, _ animator: Animator) {
        self.entity = entity
        self.animator = animator
    }
    
    func update() {
        if ActorUtility.spaceInFront(entity, float2(0.25.m, 0)) {
            animator.update()
            animator.apply(entity.material)
        }
    }
}
