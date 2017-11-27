//
//  Healer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Healer: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(15, Shield(Float(30), Float(0.1), Float(50))), float4(1), "Healer")
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(HealBehavior(self))
    }
    
}
