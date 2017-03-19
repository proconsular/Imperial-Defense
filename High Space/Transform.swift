//
//  Transform.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Transform {
    var location: float2
    var scale: float2
    var matrix: float2x2
    private(set) var parent: Transform?
    var children: [Transform]
    
    init(_ location: float2 = float2(), _ orientation: Float = 0) {
        matrix = float2x2(1)
        children = []
        scale = float2(1)
        self.location = location
        self.orientation = orientation
    }
    
    func assign(_ parent: Transform?) {
        self.parent = parent
        self.parent?.children.append(self)
    }
    
    func apply(_ vertex: float2) -> float2 {
        return (matrix * (vertex * scale) + location) * GameScreen.scale.y
    }
    
    var orientation: Float {
        set {
            let cosine = cosf(newValue)
            let sine = sinf(newValue)
            matrix = float2x2(rows: [float2(cosine, -sine), float2(sine, cosine)])
        }
        get { return atan2f(matrix.cmatrix.columns.0.y, matrix.cmatrix.columns.0.x) }
    }
    
    var global: Transform {
        get {
            let master = Transform(location, orientation)
            if let parent = parent?.global {
                master.location += parent.location
                master.orientation += parent.orientation
                //master.scale = parent.scale
            }
            return master
        }
    }
}
