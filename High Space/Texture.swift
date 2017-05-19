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
    
    func blank() {
        id = GLTextureLoader.createTexture()
        glBindTexture(GLenum(GL_TEXTURE_2D), id)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
        
        //glPixelStorei(GLenum(GL_UNPACK_ALIGNMENT), 4);
        glEnable(GLenum(GL_BLEND));
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA));
        
        let width = Int(bounds.x)
        let height = Int(bounds.y)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA8, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil)
    }
    
    func bind() {
        glBindTexture(GLenum(GL_TEXTURE_2D), id)
    }
    
    deinit {
        GLHelper.deleteTexture(id)
    }
    
}

class RenderTexture {
    
    var id: GLuint
    var texture: Texture
    
    init(_ width: Int, _ height: Int) {
        id = GLHelper.createFrameBuffer()
        texture = Texture(float2(Float(width), Float(height)))
        attach(texture)
        //print(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GLenum(GL_FRAMEBUFFER_COMPLETE))
    }
    
    func attach(_ texture: Texture) {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), id)
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texture.id, 0)
    }
    
    func capture(_ render: () -> ()) {
        GLHelper.bindFrameBuffer(id)
        glViewport(0, 0, GLsizei(texture.bounds.x), GLsizei(texture.bounds.y))
        GLHelper.clear()
        render()
        GLHelper.bindDefaultFramebuffer()
    }
    
    deinit {
        GLHelper.deleteFramebuffer(id)
    }
    
}




















