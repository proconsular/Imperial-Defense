//
//  DarkEnergyBlastBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DarkEnergyBlastBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    let transform: Transform
    var charge: Float = 0
    var mode: Int = 0
    
    var blasts: [DarkBlast]
    
    init(_ transform: Transform) {
        self.transform = transform
        blasts = []
    }
    
    func activate() {
        active = true
        charge = 0
        mode = 0
        
        let blast = DarkBlast(transform.location - float2(2.m, 0), 0.75.m, 10)
        blasts.append(blast)
        let blast1 = DarkBlast(transform.location + float2(2.m, 0), 0.75.m, 10)
        blasts.append(blast1)
    }
    
    func update() {
        charge += Time.delta
        let challenge = FinalBattle.instance.challenge
        if charge >= 1 - 0.5 * challenge && mode < blasts.count {
            charge = 0
            fire(mode)
            mode += 1
        }
        for i in 0 ..< mode {
            let blast = blasts[i]
            if let player = Player.player {
                let dl = player.transform.location - blast.transform.location
                blast.velocity += (normalize(dl) * 16.m) * Time.delta
            }
        }
        for blast in blasts {
            blast.update()
        }
        if charge >= 1.5 - challenge {
            active = false
            blasts.removeAll()
        }
    }
    
    func fire(_ index: Int) {
        let blast = blasts[index]
        if let player = Player.player {
            let dl = player.transform.location - blast.transform.location
            blast.velocity = float2()
            blast.velocity = normalize(dl) * 20.m
        }
        
    }
}
