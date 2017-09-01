//
//  Point.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/30/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Point: Shape<Edgeform> {
    var size: Float
    
    init(_ transform: Transform, _ size: Float) {
        self.size = size
        super.init(transform, Edgeform([float2()]))
    }
    
}
