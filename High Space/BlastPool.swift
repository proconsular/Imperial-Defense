//
//  BlastPool.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BlastPool {
    var blasts: [EnergyBlast]
    
    init() {
        blasts = []
    }
    
    func update() {
        blasts.forEach{ $0.update() }
        blasts = blasts.filter{ $0.alive }
    }
}
