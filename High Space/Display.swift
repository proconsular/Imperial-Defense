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
    
    init (_ id: GLuint) {
        self.id = id
    }
}

class Display {
    let visual: Visual
    let scheme: VisualScheme
    let transform: Transform
    
    init(_ hull: Hull, _ texture: GLTexture) {
        transform = hull.transform
        scheme = VisualScheme(hull, VisualInfo(texture.id))
        visual = Visual(scheme)
    }
    
    func render() {
        visual.render()
    }
    
    var color: float4 {
        get { return scheme.color }
        set { scheme.info.color = newValue }
    }
}

@objc class DisplayAdapter: NSObject {
    let display: Display
    
    init(_ location: float2, _ bounds: float2, _ texture: GLuint) {
        display = Display(Rect(location, bounds), GLTexture(texture))
        display.transform.assign(Camera.transform)
    }
    
    func render() {
        display.render()
    }
    
    var color: float4 {
        get { return display.color }
        set { display.color = newValue }
    }
    
    var location: float2 {
        get { return display.transform.location }
        set { display.transform.location = newValue }
    }
}






