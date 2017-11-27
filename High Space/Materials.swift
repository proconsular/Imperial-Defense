//
//  Render.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/22/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation


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

struct MaterialValue: Equatable {
    var name: String
    var value: Any
    var sorted: Bool = true
    
    init(_ name: String, _ value: Any) {
        self.name = name
        self.value = value
    }
}

func ==(_ prime: MaterialValue, _ second: MaterialValue) -> Bool {
    if prime.name != second.name { return false }
    if prime.value is Int {
        return isEqual(type: Int.self, a: prime.value, b: second.value) ?? false
    }
    if prime.value is GLuint {
        return isEqual(type: GLuint.self, a: prime.value, b: second.value) ?? false
    }
    if prime.value is Float {
        return isEqual(type: Float.self, a: prime.value, b: second.value) ?? false
    }
    if prime.value is float4 {
        return isEqual(type: float4.self, a: prime.value, b: second.value) ?? false
    }
    return false
}

class Material: Comparable {
    var shader: Int
    var order: Int
    
    var properties: [MaterialValue]
    var dirty = false
    
    init() {
        shader = 0
        order = 0
        properties = []
    }
    
    subscript(name: String) -> Any {
        get {
            return find(name).value
        }
        set {
            if var p = find(name) {
                p.value = newValue
                properties[findIndex(name)] = p
                dirty = true
            }else{
                properties.append(MaterialValue(name, newValue))
            }
        }
    }
    
    func find(_ name: String) -> MaterialValue! {
        for property in properties {
            if property.name == name {
                return property
            }
        }
        return nil
    }
    
    func findIndex(_ name: String) -> Int! {
        for i in 0 ..< properties.count {
            if properties[i].name == name {
                return i
            }
        }
        return nil
    }
    
    func bind() {
        
    }
}

extension Material: CustomStringConvertible {
    
    var description: String {
        var output: String = ""
        
        output += "dirty: \(dirty)"
        output += " {\n"
        
        for property in properties {
            output += property.name + ": \(property.value)"
        }
        
        output += "}\n"
        
        return output
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
        coordinates = [float2(0, 0), float2(1, 0), float2(1, 1), float2(0, 1)].rotate(3)
        super.init()
        
        self["shader"] = 0
        self["order"] = order
        self["texture"] = texture.id
        self["color"] = color
        //properties[findIndex("color")].sorted = false
    }
    
    convenience override init() {
        self.init(GLTexture(), float4(1))
    }
    
    func set(_ order: Int, _ texture: GLuint, _ coordinates: [float2]) {
        self["order"] = order
        self["texture"] = texture
        self.coordinates = coordinates
    }
    
    override func bind() {
        Graphics.bindDefault()
        glBindTexture(GLenum(GL_TEXTURE_2D), self["texture"] as! GLuint)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
    
}

class PointMaterial: Material {
    
    override init() {
        super.init()
        
        self["color"] = float4(1)
    }
    
    override func bind() {
        let _ = Graphics.bind(5)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
    
}

class ExplosionMaterial: Material {
    
    unowned let explosion: Explosion
    
    init(_ explosion: Explosion) {
        self.explosion = explosion
        super.init()
        self["color"] = float4(1)
    }
    
    override func bind() {
        let shader = Graphics.bind(6)
        shader.setProperty("color", vector4: self["color"] as! float4)
        shader.setProperty("location", vector2: transform(explosion.transform.location))
        shader.setProperty("radius", value: explosion.radius)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
    
    func transform(_ location: float2) -> float2 {
        var l = float2()
        if let cam = Camera.current {
            l = cam.transform.location
        }
        let t = location - l
        let height = Float(UIScreen.main.bounds.height * UIScreen.main.scale)
        let scale: Float = Float(1125 / height)
        let s: Float = (height - 750) / (1125 - 750)
        let m: Float = 1 - 0.04 * clamp(s, min: 0, max: 1)
        return float2(t.x, Camera.size.y - t.y) * float2(1 / scale) * float2(m)
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
        
//        properties.append(TextureProperty())
//        properties.append(ColorProperty())
    }
    
}



















