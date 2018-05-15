//
//  LifeDisplayAdapter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LifeDisplayAdapter: StatusItem {
    weak var life: Life?
    var base: float4
    var warnings: [PowerWarning]
    
    init(_ life: Life, _ color: float4) {
        self.life = life
        self.base = color
        warnings = []
    }
    
    func update() {
        if let life = life {
            warnings.forEach{ $0.update(life.percent) }
        }
    }
    
    var percent: Float {
        return life?.percent ?? 0
    }
    
    var color: float4 {
        var c = base
        warnings.forEach{ c = $0.apply(c) }
        return c
    }
}
