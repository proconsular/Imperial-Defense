//
//  DisplayAdapter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/27/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

@objc class DisplayAdapter: NSObject {
    let display: Display
    let rect: Rect
    
    @objc init(_ location: float2, _ bounds: float2, _ texture: GLuint) {
        rect = Rect(location, bounds)
        display = Display(rect, GLTexture(texture))
        //display.transform.assign(Camera.current.transform)
    }
    
    override convenience init() {
        self.init(float2(), float2(), 0)
    }
    
    func clearParent() {
        display.transform.assign(nil)
    }
    
    @objc func render() {
        display.render()
    }
    
    func refresh() {
        display.visual.refresh()
    }
    
    var color: float4 {
        get { return display.color }
        set { display.color = newValue }
    }
    
    @objc var location: float2 {
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
        get { return display.material.texture.id }
        set { display.material.texture.id = newValue }
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
        display.material.coordinates = coordinates
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
        display.scheme.schemes[0].vertices = verts
    }
}
