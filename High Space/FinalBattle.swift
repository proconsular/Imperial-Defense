//
//  Boss.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/15/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FinalBattle {
    static weak var instance: FinalBattle!
    
    init() {
        FinalBattle.instance = self
    }
    
    var challenge: Float {
        var out: Float = 0
        let c = 1 - Emperor.instance.health.stamina.percent
        let base = c / 6
        out = base
        if c > 0.25 {
            out = 0.25 + base
        }
        if c > 0.5 {
            out = 0.5 + base
        }
        if c > 0.75 {
            out = 0.75 + base
        }
        if c > 0.9 {
            out = 1
        }
        
        return clamp(out, min: 0, max: 1)
    }
    
}
