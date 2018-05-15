//
//  MaxSelector.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MaxSelector: PowerSelector {
    func select(_ power: Float, _ open: [UnitPower]) -> UnitPower {
        var selected = open.first!
        var dc = power - selected.cost
        
        for p in open {
            let pdc = power - p.cost
            if pdc < dc {
                selected = p
                dc = pdc
            }
        }
        
        return selected
    }
}
