//
//  Texture.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/22/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

@objc
class Texture: NSObject {
    
    var id: GLuint
    var bounds: float2
    
    init(_ id: GLuint, _ bounds: float2) {
        self.id = id
        self.bounds = bounds
        super.init()
    }
    
    init(_ bounds: float2) {
        id = GLTextureLoader.createTexture()
        self.bounds = bounds
        super.init()
        createBlankTexture()
    }
    
    override init() {
        id = GLTextureLoader.createTexture()
        bounds = float2()
        super.init()
    }
    
    static func computeColor(_ color: float4) -> UInt32 {
        let red = UInt32(255 * color.x)
        let green = UInt32(255 * color.y) << 8
        let blue = UInt32(255 * color.z) << 16
        let alpha = UInt32(255 * color.w) << 24
        return red | green | blue | alpha
    }
    
    private func createBlankTexture() {
        create(Array<UInt32>(repeating: 0, count: Int(bounds.x * bounds.y)))
    }
    
    func create(_ textureData: [UInt32]) {
        glBindTexture(GLenum(GL_TEXTURE_2D), id)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
        
        glPixelStorei(GLenum(GL_UNPACK_ALIGNMENT), 4);
        
        let width = Int(bounds.x)
        let height = Int(bounds.y)
        let data = textureData.asData()
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA8, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), data)
        data.deinitialize()
        data.deallocate(capacity: width * height)
    }
    
}






















