//
//  PolygonBuffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PolygonBuffer: GraphicsBuffer {
    var data: [GraphicsInfo]
    var buffer: BufferSet
    
    init(_ data: [GraphicsInfo]) {
        self.data = data
        
        var indices: [UInt16] = []
        var vertices: [Float] = []
        
        var count = 0
        
        for info in data {
            var newIndices: [UInt16] = []
            var i = 0
            
            if info.hull is Shape<Edgeform> {
                newIndices = PolygonIndexer().computeIndices(info.hull.getVertices().count)
                i = info.hull.getVertices().count
            }else{
                newIndices = DividedPolygonIndexer().computeIndices(Radialform.divides)
                i = Radialform.divides
            }
            
            indices += newIndices.map{ $0 + UInt16(count) } + [UInt16.max]
            
            vertices += GraphicsInfoCompiler(info).compile()
            count += i
        }
        
        buffer = BufferSet(indices, vertices)
    }
    
    func refresh() {
        var compiledData: [Float] = []
        for info in data {
            compiledData += GraphicsInfoCompiler(info).compile()
        }
        buffer.vertices.upload(compiledData)
    }
}
