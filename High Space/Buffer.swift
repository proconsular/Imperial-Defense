//
//  Buffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Buffer<Value> {
    let id: GLuint
    private let type: GLenum
    let data: [Value]
    
    init(_ type: GLenum, _ data: [Value], _ usage: GLenum) {
        id = GLHelper.createBuffer()
        self.data = data
        self.type = type
        glBindBuffer(type, id)
        let d = data.asData()
        glBufferData(type, data.count * MemoryLayout<Value>.size, d, usage)
        d.deinitialize()
        d.deallocate(capacity: data.count)
    }
    
    func bind() {
        glBindBuffer(type, id)
    }
    
    deinit {
        GLHelper.deleteBuffer(id)
    }
    
    func upload(_ data: [Float]) {
        bind()
        
        let size = data.count * MemoryLayout<Value>.size
        
        let memory = data.asData()
        let buffer_memory = glMapBufferRange(GLenum(GL_ARRAY_BUFFER), 0, size, GLbitfield(GL_MAP_WRITE_BIT | GL_MAP_INVALIDATE_BUFFER_BIT))
        memcpy(buffer_memory, memory, size)
        
        memory.deinitialize()
        memory.deallocate(capacity: data.count)
        
        glUnmapBuffer(GLenum(GL_ARRAY_BUFFER))
    }
}
