//
//  PointBuffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PointBuffer: GraphicsBuffer {
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
            
            newIndices = [0]
            i = info.hull.getVertices().count
            
            indices += newIndices.map{ $0 + UInt16(count) }
            
            vertices += PointCompiler(info).compile()
            count += i
        }
        
        buffer = BufferSet(indices, vertices)
    }
    
    func refresh() {
        var compiledData: [Float] = []
        for info in data {
            compiledData += PointCompiler(info).compile()
        }
        buffer.vertices.upload(compiledData)
    }
}
