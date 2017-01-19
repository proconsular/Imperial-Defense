//
//  Polygon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Polygon: Shape<Edgeform> {
    
    init(_ transform: Transform = Transform(), _ vertices: [float2]) {
        super.init(transform, Edgeform(vertices))
    }
    
}
