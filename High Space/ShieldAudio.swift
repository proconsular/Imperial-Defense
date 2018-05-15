//
//  ShieldAudio.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShieldAudio: ShieldDelegate {
    func recover(_ percent: Float) {
        if percent <= 0.9 {
            Audio.play("shield-regen", 0.2)
        }
    }
    
    func damage() {
        
    }
}
