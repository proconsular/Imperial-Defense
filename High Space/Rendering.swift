//
//  Rendering.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/18/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SingleGraphicsRenderer {
    let info: GraphicsInfo
    
    let vertex_array: VertexArray
    var buffer: BufferSet
    
    init(_ info: GraphicsInfo) {
        self.info = info
        vertex_array = VertexArray()
        buffer = BufferSet(PolygonIndexer().computeIndices(info.hull.getVertices().count), GraphicsInfoCompiler(info).compile())
    }
    
    func render() {
        
    }
    
}
