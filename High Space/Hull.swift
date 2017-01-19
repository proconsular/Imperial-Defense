//
//  Hull.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Hull {
    var transform: Transform { get set }
    func getVertices() -> [float2]
    func getBounds() -> FixedRect
    func getCircle() -> BoundingCircle
}
