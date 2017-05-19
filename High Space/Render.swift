//
//  Render.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/22/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class RenderLayout {
    
    var hull: Hull
    var material: Material
    
    init(_ hull: Hull, _ material: Material) {
        self.hull = hull
        self.material = material
    }
    
}

class RenderTranslater {
    
}




class RenderPart {
    
    var vertexArray: VertexArray
    var buffers: BufferSet!
    
    init() {
        vertexArray = VertexArray()
    }
    
    func setup() {
        vertexArray.bind()
        
    }
    
}

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
}

class BufferSet {
    
    let elements: IndexBuffer
    let vertices: VertexBuffer
    
    init(_ indices: [UInt16], _ data: [Float]) {
        elements = IndexBuffer(indices)
        vertices = VertexBuffer(data)
    }
    
}

class Buffer<Value> {
    let id: GLuint
    private let type: GLenum
    
    init(_ type: GLenum, _ data: [Value], _ usage: GLenum) {
        id = GLHelper.createBuffer()
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
    
}

class VertexBuffer: Buffer<Float> {
    
    init(_ data: [Float]) {
        super.init(GLenum(GL_ARRAY_BUFFER), data, GLenum(GL_DYNAMIC_DRAW))
    }
    
}

class IndexBuffer: Buffer<UInt16> {
    
    init(_ data: [UInt16]) {
        super.init(GLenum(GL_ELEMENT_ARRAY_BUFFER), data, GLenum(GL_STATIC_DRAW))
    }
    
}

protocol Material {
    var shader: Shader { get set }
    func bind()
    func configure()
}

class DefaultMaterial: Material {
    
    var shader: Shader
    var texture: Texture
    var color: float4
    
    init(_ texture: Texture, _ color: float4) {
        self.shader = Graphics.getShader(0)
        self.texture = texture
        self.color = color
    }
    
    func bind() {
        shader.bind()
        texture.bind()
    }
    
    func configure() {
        shader.setProperty("color", vector4: color)
    }
    
}






