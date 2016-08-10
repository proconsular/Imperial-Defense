//
//  Visual.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/29/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol Hull {
    var transform: Transform { get set }
    func getVertices() -> [float2]
    func getBounds() -> RawRect
}

protocol Form {
    func getVertices() -> [float2]
}

class Transform {
    var location: float2
    var matrix: float2x2
    private(set) var parent: Transform?
    var children: [Transform]
    
    init(_ location: float2 = float2(), _ orientation: Float = 0) {
        matrix = float2x2(1)
        children = []
        self.location = location
        self.orientation = orientation
    }
    
    func assign(parent: Transform) {
        self.parent = parent
        self.parent?.children.append(self)
    }
    
    func apply(vertex: float2) -> float2 {
        return vertex * matrix + location
    }
    
    var orientation: Float {
        set {
            let (cosine, sine) = (cosf(newValue), sinf(newValue))
            matrix = float2x2(rows: [float2(cosine, -sine), float2(sine, cosine)])
        }
        get { return atan2f(matrix.cmatrix.columns.0.y, matrix.cmatrix.columns.0.x) }
    }
    
    var global: Transform {
        get {
            let master = Transform(location, orientation)
            if let parent = parent?.global {
                master.location += parent.location
                master.orientation += parent.orientation
            }
            return master
        }
    }
}

class Shape<F: Form>: Hull {
    var transform: Transform
    var form: F
    
    init(_ transform: Transform = Transform(), _ frame: F) {
        self.transform = transform
        self.form = frame
    }
    
    func getBounds() -> RawRect {
        return RawRect(float2(), float2())
    }
    
    func getVertices() -> [float2] {
        return form.getVertices()
    }
    
    func getTransformedVertex(index: Int) -> float2 {
        return getTransformedVertex(form.getVertices()[index])
    }
    
    func getTransformedVertex(vertex: float2) -> float2 {
        return transform.apply(vertex)
    }
    
    func getTransformedFace(index: Int) -> Face {
        return Face(getTransformedVertex(index), getTransformedVertex((index + 1) % form.getVertices().count))
    }
    
}

class Edgeform: Form {
    var vertices: [float2] = []
    var normals: [float2] = []
    
    init(_ vertices: [float2]) {
        self.vertices = vertices.centered
        normals = computeNormals()
    }
    
    convenience init (_ bounds: float2) {
        self.init([float2(0), float2(0, bounds.y), bounds, float2(bounds.x, 0)])
    }
    
    func computeNormals() -> [float2] {
        var normals: [float2] = []
        vertices.count.loop {
            normals.append(getFace($0).normal)
        }
        return normals
    }
    
    func getFace(index: Int) -> Face {
        return Face(vertices[index], vertices[(index + 1) % vertices.count])
    }
    
    func getVertices() -> [float2] {
        return vertices
    }
    
    func getSupport(normal: float2) -> float2 {
        return vertices[findBestIndex(0 ..< vertices.count, -FLT_MAX, >) { dot(vertices[$0], normal) }!]
    }
}

class Polygon: Shape<Edgeform> {
    
    init(_ transform: Transform = Transform(), _ vertices: [float2]) {
        super.init(transform, Edgeform(vertices))
    }
    
}

class Rect: Shape<Edgeform> {
    var bounds: float2
    
    init(_ transform: Transform = Transform(), _ bounds: float2) {
        self.bounds = bounds
        super.init(transform, Edgeform(bounds))
    }
    
    convenience init(_ location: float2, _ bounds: float2) {
        self.init(Transform(location), bounds)
    }
    
    override func getBounds() -> RawRect {
        return RawRect(transform.location - bounds / 2, bounds)
    }
    
}

class Radialform: Form {
    
    func getVertices() -> [float2] {
        return []
    }
    
}

class Eclipse: Shape<Radialform> {
    
}

struct TextureLayout {
    var coordinates: [float2]
    
    init(_ coordinates: [float2]) {
        self.coordinates = coordinates
    }
    
    init(_ hull: Hull) {
        self.coordinates = TextureLayout.generateCoordinates(hull)
    }
    
    private static func generateCoordinates(hull: Hull) -> [float2] {
        let vertices = hull.getVertices()
        let center = vertices.center
        
        var coordinates: [float2] = []
        
        for vertex in vertices {
            let angle = atan2f(vertex.y - center.y, vertex.x - center.x)
            coordinates.append(float2(cosf(angle) / 1.5 + 0.5, sinf(angle) / 1.5 + 0.5))
        }
        
        return coordinates
    }
}

struct VisualInfo {
    var texture: UInt32
    var color: float4
    
    init(_ texture: UInt32, _ color: float4 = float4(1)) {
        self.texture = texture
        self.color = color
    }
}

protocol Scheme {
    func getRawScheme() -> RawScheme
}

class VisualScheme: Scheme {
    var hull: Hull
    var layout: TextureLayout
    var info: VisualInfo
    
    init(_ hull: Hull, _ layout: TextureLayout, _ info: VisualInfo) {
        self.hull = hull
        self.layout = layout
        self.info = info
    }
    
    convenience init(_ hull: Hull, _ info: VisualInfo) {
        self.init(hull, TextureLayout(hull), info)
    }
    
    func getRawScheme() -> RawScheme {
        return RawVisualScheme(self)
    }
    
    var vertices: [float2] {
        return hull.getVertices()
    }
    
    var coordinates: [float2] {
        return layout.coordinates
    }
    
    var color: float4 {
        return info.color
    }
    
    var texture: UInt32 {
        return info.texture
    }
}

class VisualSchemeGroup: Scheme {
    var schemes: [VisualScheme]
    
    init(schemes: [VisualScheme]) {
        self.schemes = schemes
    }
    
    func getRawScheme() -> RawScheme {
        return RawVisualSchemeGroup(self)
    }
}

class Visual {
    let scheme: Scheme
    var display: VisualDisplay!
    
    init(_ scheme: Scheme) {
        self.scheme = scheme
    }
    
    func verify() {
        if display == nil {
            display = GLVisualDisplay(scheme.getRawScheme())
        }
    }
    
    func refresh() {
        verify()
        display.refresh()
    }
    
    func render() {
        verify()
        display.render()
    }
}

class VisualRectScheme: VisualScheme {
    
    init(_ location: float2, _ bounds: float2, _ layout: TextureLayout, _ texture: VisualInfo) {
        let rect = Rect(Transform(location), bounds)
        super.init(rect, layout, texture)
    }
    
    init(_ location: float2, _ bounds: float2, _ layout: TextureLayout, _ texture: String) {
        let rect = Rect(Transform(location), bounds)
        super.init(rect, layout, VisualInfo(0))
    }
    
    convenience init(_ location: float2, _ bounds: float2, _ texture: String) {
        let rect = Rect(Transform(location), bounds)
        self.init(location, bounds, TextureLayout(rect), texture)
    }
    
}





















