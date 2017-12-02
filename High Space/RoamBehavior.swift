//
//  RoamBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RoamBehavior: CooldownBehavior {
    unowned var soldier: Soldier
    
    init(_ soldier: Soldier, _ limit: Float) {
        self.soldier = soldier
        super.init(limit)
    }
    
    override func activate() {
        super.activate()
        soldier.animator.set(1)
        let complex = ComplexBehavior()
        complex.append(MoveBehavior(soldier.body, float2(random(-0.75.m, 0.75.m), 0)))
        complex.append(MarchBehavior(soldier, soldier.animator))
        soldier.behavior.push(TemporaryBehavior(complex, 1) { [unowned soldier] in
            soldier.animator.set(0)
        })
    }
    
}

class MoveBehavior: Behavior {
    var alive: Bool = true
    
    unowned let body: Body
    var vector: float2
    
    init(_ body: Body, _ vector: float2) {
        self.body = body
        self.vector = vector
    }
    
    func update() {
        body.location += vector * Time.delta
    }
}