//
//  EnergyWavePower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EnergyWavePower: TimedUnitPower {
    
    unowned let transform: Transform
    var waves: [EnergyWave]
    
    init(_ transform: Transform, _ cost: Float, _ wait: Float) {
        self.transform = transform
        waves = []
        super.init(cost, wait)
    }
    
    override func invoke() {
        super.invoke()
        
        var angle = atan2f(1, random(-0.25, 0.25))
        
        if let player = Player.player {
            let dl = player.transform.location - transform.location
            angle = atan2f(dl.y, dl.x)
        }
        
        for i in 0 ..< 2 {
            waves.append(EnergyWave(transform.location, Float(i) * 0.005.m + 0.05.m, angle))
        }
        
        Audio.play("wave-blast", 0.5)
    }
    
    override func update() {
        super.update()
        waves = waves.filter{ $0.alive }
        waves.forEach{ $0.update() }
    }
    
}
















