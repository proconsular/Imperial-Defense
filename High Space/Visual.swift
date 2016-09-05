//
//  Visual.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/29/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation


struct BoundingCircle {
    var location: float2
    var radius: Float
    
    init(_ location: float2, _ radius: Float) {
        self.location = location
        self.radius = radius
    }
    
    func intersects(other: BoundingCircle) -> Bool {
        let dl = (location - other.location).length
        let dr = radius + other.radius
        return dl <= dr
    }
}

protocol Hull {
    var transform: Transform { get set }
    func getVertices() -> [float2]
    func getBounds() -> FixedRect
    func getCircle() -> BoundingCircle
}

protocol Form {
    func getVertices() -> [float2]
}

class Transform {
    var location: float2
    private(set) var matrix: float2x2
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
        return matrix * vertex + location
    }
    
    var orientation: Float {
        set {
            let cosine = cosf(newValue)
            let sine = sinf(newValue)
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
    var circle: BoundingCircle
    
    init(_ transform: Transform = Transform(), _ frame: F) {
        self.transform = transform
        self.form = frame
        circle = BoundingCircle(float2(), 0)
        computeBoundingCircle()
    }
    
    func getBounds() -> FixedRect {
        return FixedRect(float2(), float2())
    }
    
    private func computeBoundingCircle() {
        let vertices = form.getVertices()
        let center = vertices.center
        let radius = findBestValue(0 ..< vertices.count, -FLT_MAX, >) {
            return (center - vertices[$0]).length
            }!
        circle = BoundingCircle(center, radius)
    }
    
    func getCircle() -> BoundingCircle {
        circle.location = transform.location
        return circle
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
        let next = index + 1 >= form.getVertices().count ? 0 : index + 1
        return Face(getTransformedVertex(index), getTransformedVertex(next))
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
        let next = index + 1 >= vertices.count ? 0 : index + 1
        return Face(vertices[index], vertices[next])
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
    private(set) var bounds: float2
    private var rect: FixedRect
    
    init(_ transform: Transform = Transform(), _ bounds: float2) {
        self.bounds = bounds
        rect = FixedRect(float2(), float2())
        super.init(transform, Edgeform(bounds))
        computeRect()
    }
    
    convenience init(_ location: float2, _ bounds: float2) {
        self.init(Transform(location), bounds)
    }
    
    override func getBounds() -> FixedRect {
        rect.location = transform.location
        return rect
    }
    
    private func computeRect() {
        var min = float2(FLT_MAX, -FLT_MAX), max = float2(-FLT_MAX, FLT_MAX)
        
        for n in 0 ..< form.vertices.count {
            let vertex = getTransformedVertex(n) - transform.location
            
            if vertex.x > max.x {
                max.x = vertex.x
            }
            if vertex.y < max.y {
                max.y = vertex.y
            }
            if vertex.x < min.x {
                min.x = vertex.x
            }
            if vertex.y > min.y {
                min.y = vertex.y
            }
        }
        
        rect = FixedRect(transform.location, float2(max.x - min.x, -max.y + min.y))
    }
    
    func setBounds(newBounds: float2) {
        self.bounds = newBounds
        form = Edgeform(newBounds)
        computeBoundingCircle()
        computeRect()
    }
    
}

class Radialform: Form {
    let divides = 40
    var vertices: [float2] = []
    var radius: Float
    
    init(_ radius: Float) {
        self.radius = radius
        vertices = computeVertices(radius).centered
    }
    
    private func computeVertices(radius: Float) -> [float2] {
        var verts: [float2] = []
        
        verts.append(float2())
        
        for n in 1 ..< divides + 1 {
            let percent = Float(n - 1) / Float(divides)
            let angle = percent * Float(M_PI * 2)
            verts.append(radius * float2(cosf(angle), sinf(angle)))
        }
        
        return verts
    }
    
    func getVertices() -> [float2] {
        return vertices
    }
}

class Circle: Shape<Radialform> {
    
    init(_ transform: Transform, _ radius: Float) {
        super.init(transform, Radialform(radius))
    }
    
    override func getBounds() -> FixedRect {
        return FixedRect(transform.location, float2(form.radius * 2))
    }
    
    func setRadius(radius: Float) {
        form = Radialform(radius)
    }
}

struct TextureLayout {
    var coordinates: [float2]
    
    init(_ coordinates: [float2]) {
        self.coordinates = coordinates
    }
    
    init(_ hull: Hull) {
        if hull is Rect {
            self.coordinates = [float2(0, 0), float2(0, 1), float2(1, 1), float2(1, 0)]
        }else{
            self.coordinates = TextureLayout.generateCoordinates(hull)
        }
    }
    
    private static func generateCoordinates(hull: Hull) -> [float2] {
        let vertices = hull.getVertices().dropFirst()
        
        var coordinates: [float2] = []
        
        coordinates.append(float2(0.5))
        
        for vertex in vertices {
            let angle = atan2f(vertex.y, vertex.x)
            coordinates.append(float2(cosf(angle) / 2 + 0.5, sinf(angle) / 2 + 0.5))
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





















