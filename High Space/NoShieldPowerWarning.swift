//
//  NoShieldPowerWarning.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class NoShieldPowerWarning: ShieldLowPowerWarning {
    unowned let shield: Shield
    
    init(_ shield: Shield, _ color: float4, _ frequency: Float) {
        self.shield = shield
        super.init(color, frequency, 1)
    }
    
    override func update(_ percent: Float) {
        if shield.percent <= 0 {
            super.update(percent)
        }else{
            active = false
        }
    }
    
    override func notify() {
        Audio.play("health_warning", 0.4)
    }
}
