//
//  HomingFirer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class HomingFirer: Firer {
    
    func fire(_ location: float2, _ target: Entity) {
        let bullet = HomingBullet(location, target, computeFinalImpact(), casing)
        Map.current.append(bullet)
        counter = 0
    }
    
}
