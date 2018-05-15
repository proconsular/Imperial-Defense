//
//  FireEnergy.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class FireEnergy: Particle {
    var effect: ColorEffect? = FlashEffect()
    
    override func update() {
        super.update()
        
        if let effect = effect {
            handle.material["color"] = effect.affect(color) * opacity
            effect.update()
        }
        
        if let player = Player.player {
            let dl = player.transform.location - transform.global.location
            if dl.length <= size * 3 && opacity >= 0.1 {
                Player.player.damage(10)
                alive = false
            }
        }
    }
}
