//
//  ShieldAbsorbEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShieldAbsorbEffect: ShieldEffect {
    unowned let transform: Transform
    unowned let shield: Shield
    let absorb: AbsorbEffect
    var percent: Float
    
    init(_ transform: Transform, _ shield: Shield, _ absorb: AbsorbEffect) {
        self.transform = transform
        self.shield = shield
        self.absorb = absorb
        percent = 0
    }
    
    func update() {
        absorb.update()
        if shield.broke {
            shield.explode(transform)
        }
        if shield.percent > percent {
            absorb.generate()
        }
        percent = shield.percent
    }
}
