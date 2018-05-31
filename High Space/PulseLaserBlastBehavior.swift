//
//  PulseLaserBlastBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PulseLaserBlastBehavior: LaserBlastBehavior {
    var charge: Float
    unowned let guideLaser: Laser
    
    init(_ laser: Laser, _ guideLaser: Laser, _ shield: ParticleShield) {
        self.guideLaser = guideLaser
        charge = 0
        super.init(0, 1, laser, shield)
        damage = 100
    }
    
    override func activate() {
        active = true
        power = 1
        laser.visible = true
        shield.set(CollapseEffect(power))
        laser.direction = guideLaser.direction
        charge = 0
    }
    
    override func update() {
        charge += Time.delta
        if charge >= 0.25 {
            super.update()
        }
    }
    
    override func move() {}
}
