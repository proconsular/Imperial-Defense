//
//  WarningLaserBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class WarningLaserBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    unowned let laser: Laser
    let length: Float
    var angle: Float
    
    var counter: Float = 0
    var set = false
    
    init(_ laser: Laser, _ length: Float) {
        self.laser = laser
        self.length = length
        angle = 0
    }
    
    convenience init(_ laser: Laser, _ angle: Float, _ length: Float) {
        self.init(laser, length)
        self.angle = angle
        set = true
    }
    
    func activate() {
        active = true
        laser.visible = true
        counter = length
        if set {
            laser.direction = vectorize(angle)
        }else{
            laser.direction = normalize(Player.player.transform.location - Emperor.instance.transform.location)
        }
    }
    
    func update() {
        counter -= Time.delta
        if counter <= 0 {
            active = false
            laser.visible = false
        }
    }
}
