//
//  SchemeCompiler.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SchemeCompiler: GraphicDataCompiler {
    let scheme: VisualScheme
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
    }
    
    func compile() -> [Float] {
        var compiled: [Float] = []
        
        let vertices = scheme.vertices
        let coordinates = scheme.coordinates
        let color = scheme.color
        
        for i in 0 ..< vertices.count {
            compiled.append(contentsOf: [vertices[i].x, vertices[i].y, coordinates[i].x, coordinates[i].y, color.x, color.y, color.z, color.w])
        }
        
        return compiled
    }
}
