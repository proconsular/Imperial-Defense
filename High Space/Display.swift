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
        id = TextureRepo.sharedLibrary().texture(withName: name)
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
    let rect: Rect
    
    init(_ location: float2, _ bounds: float2, _ texture: GLuint) {
        rect = Rect(location, bounds)
        display = Display(rect, GLTexture(texture))
        display.transform.assign(Camera.transform)
    }
    
    override convenience init() {
        self.init(float2(), float2(), 0)
    }
    
    func clearParent() {
        display.transform.assign(nil)
    }
    
    func render() {
        display.render()
    }
    
    func refresh() {
        display.visual.refresh()
    }
    
    var color: float4 {
        get { return display.color }
        set { display.color = newValue }
    }
    
    var location: float2 {
        get { return display.transform.location }
        set { display.transform.location = newValue }
    }
    
    var bounds: float2 {
        get { return rect.bounds }
        set { rect.setBounds(newValue) }
    }
    
    var rotation: Float {
        get { return display.transform.orientation }
        set { display.transform.orientation = newValue }
    }
    
    var texture: GLuint {
        get { return display.scheme.texture }
        set { display.scheme.info.texture = newValue }
    }
    
    func setMatrix(_ row0: float2, _ row1: float2) {
        display.transform.matrix = float2x2(rows: [row0, row1])
    }
    
    func setCoordinates(_ uvs: UnsafePointer<Float>, _ length: Int) {
        var coordinates: [float2] = []
        var coors = uvs
        for _ in 0 ..< length / 2 {
            var vertex = float2()
            vertex.x = coors.pointee
            coors = coors.successor()
            vertex.y = coors.pointee
            coors = coors.successor()
            coordinates.append(vertex)
        }
        display.scheme.layout.coordinates = coordinates
    }
    
    func setVertices(_ vertices: UnsafePointer<Float>, _ length: Int) {
        var verts: [float2] = []
        var vert = vertices
        for _ in 0 ..< length / 2 {
            var vertex = float2()
            vertex.x = vert.pointee
            vert = vert.successor()
            vertex.y = vert.pointee
            vert = vert.successor()
            verts.append(vertex)
        }
        display.scheme.vertices = verts
    }
}






