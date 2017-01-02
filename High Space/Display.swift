//
//  Display.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Display {
    let transform: Transform
    
    let scheme: VisualScheme
    let visual: Visual
    
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
    
    var texture: GLuint {
        get { return scheme.texture }
        set { scheme.info.texture = newValue }
    }
}







