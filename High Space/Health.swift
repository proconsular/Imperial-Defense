//
//  Health.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Health: Life {
    var shield: Shield?
    let stamina: Stamina
    
    init(_ amount: Float, _ shield: Shield?) {
        stamina = Stamina(amount)
        self.shield = shield
    }
    
    func damage(_ amount: Float) {
        var final_amount: Float = amount
        if let shield = shield {
            final_amount = max(amount - shield.points.amount, 0)
            shield.damage(amount)
        }
        stamina.damage(final_amount)
    }
    
    var percent: Float {
        return ((shield?.percent ?? 0) + stamina.percent) / 2
    }
}
