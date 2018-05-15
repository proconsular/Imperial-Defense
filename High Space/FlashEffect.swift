//
//  FlashEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class FlashEffect: ColorEffect {
    var phase = true
    var counter: Float = 0
    var rate: Float = 0.25
    
    func affect(_ color: float4) -> float4 {
        return phase ? color : float4(1)
    }
    
    func update() {
        counter += Time.delta
        if counter >= rate {
            counter = 0
            phase = !phase
        }
    }
}
