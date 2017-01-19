//
//  Circle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Circle: Shape<Radialform> {
    
    init(_ transform: Transform, _ radius: Float) {
        super.init(transform, Radialform(radius))
    }
    
    override func getBounds() -> FixedRect {
        return FixedRect(transform.location, float2(form.radius * 2))
    }
    
    func setRadius(_ radius: Float) {
        form = Radialform(radius)
    }
}
