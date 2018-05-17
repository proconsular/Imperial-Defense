//
//  GraphicsInfoCompiler.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GraphicsInfoCompiler: GraphicDataCompiler {
    let info: GraphicsInfo
    
    init(_ info: GraphicsInfo) {
        self.info = info
    }
    
    func compile() -> [Float] {
        var compiled: [Float] = []
        
        let vertices = info.hull.getVertices()
        let material = info.material as! ClassicMaterial
        let coordinates = material.coordinates
        let color = info.material["color"] as! float4
        
        for i in 0 ..< vertices.count {
            let vertex = info.hull.transform.apply(vertices[i])
            compiled.append(contentsOf: [vertex.x, vertex.y, coordinates[i].x, coordinates[i].y, color.x, color.y, color.z, color.w])
        }
        
        return compiled
    }
}
