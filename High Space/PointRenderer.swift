//
//  PointRenderer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/30/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PointRenderer: BaseRenderer {
    
    override func enable() {
        VertexArray.enableAttribute(.position)
        VertexArray.enableAttribute(.normal)
        VertexArray.enableAttribute(.color)
    }
    
    override func compile() {
        array.bind()
        buffer = PointBuffer(graphics)
        VertexArray.enableAttributePointer(.position, 2, GLboolean(GL_FALSE), 32, 0)
        VertexArray.enableAttributePointer(.normal, 2, GLboolean(GL_FALSE), 32, 8)
        VertexArray.enableAttributePointer(.color, 4, GLboolean(GL_FALSE), 32, 16)
    }
    
    override func draw() {
        //glDrawElements(GLenum(GL_POINTS), GLsizei(buffer.buffer.elements.data.count), GLenum(GL_UNSIGNED_SHORT), nil)
        glDrawArrays(GLenum(GL_POINTS), 0, GLsizei(graphics.count))
    }
    
}

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

