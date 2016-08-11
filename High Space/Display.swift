//
//  Display.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class GLTexture {
    var id: GLuint
    
    init(_ name: String) {
        id = TextureRepo.sharedLibrary().textureWithName(name)
    }
}

class Display {
    let visual: Visual
    let scheme: VisualScheme
    
    init(_ hull: Hull, _ texture: GLTexture) {
        scheme = VisualScheme(hull, VisualInfo(texture.id))
        visual = Visual(scheme)
    }
    
    func render() {
        visual.render()
    }
}