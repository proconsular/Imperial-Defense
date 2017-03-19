//
//  Lighting.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/7/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Light {
    static let threshold: Float = 0.00001
    
    var location: float2
    var brightness: Float
    var attenuation: Float
    var temperature: Float
    var dissipation: Float
    var color: float4
    
    var display: Display!
    var faces: [Face]
    
    init(_ location: float2, _ brightness: Float, _ attenuation: Float, _ temperature: Float, _ dissipation: Float, _ color: float4 = float4(1)) {
        self.location = location
        self.brightness = brightness
        self.attenuation = attenuation
        self.temperature = temperature
        self.dissipation = dissipation
        self.color = color
        faces = []
        let rect = Rect(Transform(float2()), float2(radius * 2))
        display = Display(rect, GLTexture("white"))
    }
    
    var radius: Float {
        return log(Light.threshold * brightness) / attenuation
    }
    
    func getValidFaces(_ shape: Shape<Edgeform>) -> [Face] {
        var faces: [Face] = []
        var indices: [Int] = []
        for i in 0 ..< shape.form.vertices.count {
            let face = shape.getTransformedFace(i)
            let vector = normalize(face.center - location)
            if length(vector + face.normal) < Float(M_SQRT2) {
                faces.append(face)
                indices.append(i)
            }
        }
        if indices.contains(0) && indices.contains(3) { faces = faces.reversed() }
        return faces
    }
    
    func getVertices(_ faces: [Face]) -> [float2] {
        var vertices: [float2] = []
        for face in faces {
            for vertex in [face.first, face.second] {
                vertices.append(vertex)
            }
        }
        return vertices
    }
    
    func filterVertices(_ vertices: [float2]) -> Face? {
        var clone = float2(Float.infinity)
        vertices.match{ if $0 == $1 { clone = $0 } }
        let vs = vertices.filter{ $0 != clone }
        if vs.isEmpty { return nil }
        return Face(vs.first!, vs.last!)
    }
    
    func getFaces(_ shapes: [Shape<Edgeform>]) -> [Face] {
        var faces: [Face] = []
        for shape in shapes {
            if let face = getFace(shape) { faces.append(face) }
        }
        return faces
    }
    
    func getFace(_ shape: Shape<Edgeform>) -> Face? {
        let faces = getValidFaces(shape)
        let verts = getVertices(faces)
        return filterVertices(verts)
    }
    
    func isLit(_ vertex: float2, _ face: Face) -> Bool {
        guard cross(face.first - location, vertex - location).z > 0 else { return true }
        guard cross(vertex - location, face.second - location).z > 0 else { return true }
        return computeSide(location, face) == computeSide(vertex, face)
    }
    
    func computeSide(_ vertex: float2, _ face: Face) -> Bool {
        return cross(face.vector, vertex - face.center).z < 0
    }
    
    func transform(_ location: float2) -> float2 {
        let t = location - Camera.current.transform.location
        return float2(t.x, Camera.size.y - t.y) * float2(0.96, 0.96)
    }
    
    func render() {
        let shader = Graphics.shaders[1]
        
        shader.setProperty("light.location", vector2: transform(location))
        shader.setProperty("light.color", vector4: color)
        shader.setProperty("light.brightness", value: brightness)
        shader.setProperty("light.attenuation", value: attenuation)
        shader.setProperty("light.temperature", value: temperature)
        shader.setProperty("light.dissipation", value: dissipation)
        shader.setProperty("count", intvalue: Int32(faces.count))
        
        for i in 0 ..< faces.count {
            let face = faces[i]
            shader.setProperty("faces[\(i)].first", vector2: transform(face.first))
            shader.setProperty("faces[\(i)].second", vector2: transform(face.second))
            shader.setProperty("faces[\(i)].center", vector2: transform(face.center))
        }
        
        display.render()
    }
    
}
