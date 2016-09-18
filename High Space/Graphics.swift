//
//  Graphics.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/23/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

enum Program: Int {
    case `default`, lighting
}

extension GLuint {
    
}

@objc
class Graphics: NSObject {
    
    static var shaders = [Shader] ()
    //private static var framebuffer = RenderImage()
    
    //static var image: Image?
    
//    static var generatedTexture: GLuint {
//        get {
//            let texture = framebuffer.getTexture()
//            //framebuffer.attachNewTexture()
//            return texture
//        }
//    }
    
    static func append (_ shader: Shader) {
        shaders.append(shader)
    }
    
    static func getShader (_ index: Program) -> Shader {
        return shaders[index.rawValue]
    }
    
    static func bind (_ index: Program) -> Shader {
        return getShader(index).bind()
    }
    
    static func bindDefault() {
        getShader(.default).bind()
    }
    
//    static func render (image: Image) {
//        framebuffer.renderImage(image)
//    }
//    
//    static func renderSequence (sequence: () -> ()) {
//        framebuffer.renderSequence(sequence)
//    }
//    
//    static func renderCommand (@autoclosure(escaping) command: () -> ()) {
//        framebuffer.renderSequence(command)
//    }
    
//    static func generateTexture (image: Image) -> GLuint {
//        Graphics.render(image)
//        return Graphics.generatedTexture
//    }
//    
//    static func generateTexture (image: Image, passes: Int) -> GLuint {
//        var finalTexture: GLuint = generateTexture(image)
//        for _ in 0 ..< passes - 1 {
//            finalTexture = generateTexture(Image(texture: finalTexture))
//        }
//        return finalTexture
//    }
//    
    static func clear () {
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
    }
//    
//    static func display () {
//        if image == .None {
//            image = generatedTexture.asImage
//        }
//        image?.display()
//    }
    
}
