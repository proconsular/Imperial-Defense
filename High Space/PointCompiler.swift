//
//  GraphicData.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PointCompiler: GraphicDataCompiler {
    let info: GraphicsInfo
    
    init(_ info: GraphicsInfo) {
        self.info = info
    }
    
    func compile() -> [Float] {
        let vertices = info.hull.getVertices()
        
        var size: Float = 1
        
        if let point = info.hull as? Point {
            size = point.size
        }
        
        let color = info.material["color"] as! float4
        
        let vertex = info.hull.transform.apply(vertices[0])
        
        let scale = 1 / Float(1125 / (UIScreen.main.bounds.height * UIScreen.main.scale))
        
        return [vertex.x, vertex.y, size * scale, 0, color.x, color.y, color.z, color.w]
    }
}




















