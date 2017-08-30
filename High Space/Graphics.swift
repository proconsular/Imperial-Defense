//
//  Graphics.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/23/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

@objc
class Graphics: NSObject {
    
    static var shaders = [Shader] ()
    
    static var method: GraphicsMethod = SingleRendererMethod()
    
    static func append (_ shader: Shader) {
        shaders.append(shader)
    }
    
    static func getShader (_ index: Int) -> Shader {
        return shaders[index]
    }
    
    static func bind (_ index: Int) -> Shader {
        return getShader(index).bind()
    }
    
    static func bindDefault() {
        getShader(0).bind()
    }
    
    static func clear () {
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
    }
    
    static func create(_ info: GraphicsInfo) {
        method.create(info)
    }
    
    static func update() {
        method.update()
    }
    
    static func render() {
        method.render()
    }
    
}
