//
//  GraphicsInfo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GraphicsInfo {
    var active: Bool
    let hull: Hull
    var materials: [Material]
    
    init(_ hull: Hull, _ material: Material) {
        self.hull = hull
        materials = []
        materials.append(material)
        active = true
    }
    
    var material: Material {
        get { return materials[0] }
        set { materials[0] = newValue }
    }
}
