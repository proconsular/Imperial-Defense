//
//  Weapon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Weapon {
    
    unowned var transform: Transform
    var direction: float2
    var offset: float2 = float2()
    
    var firer: Firer
    
    init(_ transform: Transform, _ direction: float2, _ firer: Firer) {
        self.transform = transform
        self.direction = direction
        self.firer = firer
    }
    
    func update() {
        firer.update()
    }
    
    func fire() {
        firer.fire(firepoint, direction)
    }
    
    var firepoint: float2 {
        return transform.location + 0.75.m * direction + offset
    }
    
    var canFire: Bool {
        return firer.operable
    }
    
}















