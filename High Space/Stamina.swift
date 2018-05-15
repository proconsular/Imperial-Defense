//
//  Stamina.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Stamina: Life {
    var points: PointRange
    
    init(_ limit: Float) {
        points = PointRange(limit)
    }
    
    func damage(_ amount: Float) {
        points.increase(-amount)
    }
    
    var percent: Float {
        return points.percent
    }
}
