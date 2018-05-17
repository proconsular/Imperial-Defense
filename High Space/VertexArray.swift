//
//  VertexArray.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class VertexArray {
    let id: GLuint
    
    init() {
        id = GLHelper.createVertexArray()
    }
    
    func bind() {
        glBindVertexArrayOES(id)
    }
    
    deinit {
        GLHelper.deleteVertexArray(id)
    }
    
    static func enableAttribute(_ attribute: GLKVertexAttrib) {
        glEnableVertexAttribArray(GLuint(attribute.rawValue))
    }
    
    static func enableAttributePointer(_ attribute: GLKVertexAttrib, _ size: Int, _ normalized: GLboolean, _ stride: Int, _ offset: Int) {
        glVertexAttribPointer(GLuint(attribute.rawValue), GLint(size), GLenum(GL_FLOAT), normalized, GLsizei(stride), GLHelper.createOffset(Int32(offset)))
    }
    
    static func enableAttributes() {
        VertexArray.enableAttributePointer(.position, 2, GLboolean(GL_FALSE), 32, 0)
        VertexArray.enableAttributePointer(.texCoord0, 2, GLboolean(GL_FALSE), 32, 8)
        VertexArray.enableAttributePointer(.color, 4, GLboolean(GL_FALSE), 32, 16)
    }
}
