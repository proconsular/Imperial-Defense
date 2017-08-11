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

class Material: Comparable {
    unowned var shader: Shader
    var order: Int
    
    var properties: [MaterialProperty]
    
    init() {
        self.shader = Graphics.getShader(0)
        order = 0
        properties = []
    }
}

func ==(_ prime: Material, _ second: Material) -> Bool {
    return prime.order == second.order
}

func <(_ prime: Material, _ second: Material) -> Bool {
    return prime.order < second.order
}

func >(_ prime: Material, _ second: Material) -> Bool {
    return  prime.order > second.order
}

func <=(_ prime: Material, _ second: Material) -> Bool {
    return  prime.order <= second.order
}

func >=(_ prime: Material, _ second: Material) -> Bool {
    return  prime.order >= second.order
}

class ClassicMaterial: Material {
    
    var texture: GLTexture
    var coordinates: [float2]
    var color: float4
    
    init(_ texture: GLTexture, _ color: float4 = float4(1)) {
        self.texture = texture
        self.color = color
        coordinates = []
        super.init()
    }
    
    convenience override init() {
        self.init(GLTexture(), float4(1))
    }
    
}

protocol MaterialProperty {
    var order: Int { get set }
    
    func bind()
}

class TextureProperty: MaterialProperty {
    var order: Int = 0
    
    var value: Int
    
    init() {
        value = 0
    }
    
    func bind() {
        glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(value))
    }
}

class TextureCoordinates {
    var coordinates: [float2]
    
    init() {
        coordinates = []
    }
}

class ColorProperty: MaterialProperty {
    var order: Int = 2
    
    var color: float4
    
    init() {
        color = float4(1)
    }
    
    func bind() {
        
    }
}

class TextualMaterialProperty: MaterialProperty {
    var order: Int = 3
    
    var name: String
    var value: Any!
    
    init(_ name: String) {
        self.name = name
    }
    
    func bind() {
        
    }
    
}

class DefaultMaterial: Material {
    
    override init() {
        super.init()
        
        properties.append(TextureProperty())
        properties.append(ColorProperty())
    }
    
}

class DummyMaterial: Material {
    
    override init() {
        super.init()
        
        properties.append(TextualMaterialProperty("color"))
        
    }
    
}





















