//
//  Render.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/22/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

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



















