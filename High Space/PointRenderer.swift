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

