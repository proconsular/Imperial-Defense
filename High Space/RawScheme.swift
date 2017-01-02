//
//  RawScheme.swift
//  Defender
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

@objc
class RawVisualScheme: NSObject, RawScheme {
    let scheme: VisualScheme
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
    }
    
    func getCompiledBufferData() -> UnsafeMutablePointer<Float> {
        var compiled: [Float] = []
        
        let vertices = scheme.vertices
        let coordinates = scheme.coordinates
        let color = scheme.color
        
        for i in 0 ..< vertices.count {
            compiled.append(contentsOf: [vertices[i].x, vertices[i].y, coordinates[i].x, coordinates[i].y, color.x, color.y, color.z, color.w])
        }
        
        return compiled.asData()
    }
    
    func getCompiledBufferDataSize() -> Int32 {
        return Int32(amountOfNumbers * 6 * MemoryLayout<Float>.size)
    }
    
    func getIndicesArray(_ offset: Int = 0) -> [UInt16] {
        var indices: [UInt16] = []
        
        if scheme.hull is Circle {
            indices.append(contentsOf: computeCircleIndices())
        }else{
            indices.append(contentsOf: computePolygonIndices())
        }
        
        return indices.map{ $0 + UInt16(offset) }
    }
    
    private func computeCircleIndices() -> [UInt16] {
        var indices: [UInt16] = []
        
        let circle = scheme.hull as! Circle
        let count = circle.form.divides
        
        var m = 1
        for i in 0 ..< count {
            let a = i % 2 == 1 ? i + 1 : 0
            let c = i % 2 == 0 ? i + 2 : 0
            m += i % 2 == 1 ? 2 : 0
            
            indices.append(UInt16(a))
            indices.append(UInt16(i == count - 1 && i % 2 == 1 ? 1 : m))
            indices.append(UInt16(i == count - 1 && i & 2 == 0 ? 1 : c))
        }
        
        return indices
    }
    
    private func computePolygonIndices() -> [UInt16] {
        let count = amountOfSides
        var indices: [UInt16] = []
        
        var m = 1
        for i in 0 ..< count / 2 {
            let i0 = i % 2 == 0
            let i1 = i % 2 == 1
            let ic = i == count - 1
            
            m += (i1 ? 2 : 0)
            indices.append(UInt16((i1 ? i + 1 : 0)))
            indices.append(UInt16(ic && i1 ? 1 : m))
            indices.append(UInt16((ic && i0 ? 1 : (i0 ? i + 2 : 0))))
        }
        
        return indices
    }
    
    func getIndices() -> UnsafeMutablePointer<UInt16> {
        return getIndicesArray().asData()
    }
    
    func getIndexBufferSize() -> Int32 {
        if let circle = scheme.hull as? Circle {
            return Int32(circle.form.divides * 6)
        }
        return Int32(amountOfIndices)
    }
    
    var amountOfIndices: Int {
        return amountOfSides * 3
    }
    
    var amountOfSides: Int {
        return scheme.vertices.count
    }
    
    var amountOfNumbers: Int {
        return scheme.vertices.count * 2
    }
    
    func getMatrix() -> GLKMatrix4 {
        let global = scheme.hull.transform.global
        let location = global.location - (scheme.camera ? Camera.transform.location : float2())
        let orientation = global.orientation
        let matrix = GLKMatrix4RotateZ(GLKMatrix4MakeTranslation(location.x, location.y, 0), orientation)
        return matrix
    }
    
    func getTexture() -> GLuint {
        return scheme.texture
    }
    
}
