//
//  VisualHelpers.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 6/17/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
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
            compiled.appendContentsOf([
                vertices[i].x,
                vertices[i].y,
                coordinates[i].x,
                coordinates[i].y,
                color.x,
                color.y,
                color.z,
                color.w
            ])
        }
        
        return compiled.asData()
    }
    
    func getCompiledBufferDataSize() -> Int32 {
        return Int32(amountOfNumbers * 6 * sizeof(Float))
    }
    
    func getIndicesArray(offset: Int = 0) -> [UInt16] {
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
        
        return indices.map{ $0 + UInt16(offset) }
    }
    
    func getIndices() -> UnsafeMutablePointer<UInt16> {
        return getIndicesArray().asData()
    }
    
    func getIndexBufferSize() -> Int32 {
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
        let location = global.location - Camera.transform.global.location
        let orientation = global.orientation
        return GLKMatrix4RotateZ(GLKMatrix4MakeTranslation(location.x, location.y, 0), orientation)
    }
    
    func getTexture() -> GLuint {
        return scheme.texture
    }
    
}

@objc
class RawVisualSchemeGroup: NSObject, RawScheme {
    let group: VisualSchemeGroup
    var index_count: Int32 = 0
    
    init(_ group: VisualSchemeGroup) {
        self.group = group
    }
    
    func getCompiledBufferData() -> UnsafeMutablePointer<Float> {
        var compiled: [Float] = []
        
        let schemes = group.schemes
        
        for scheme in schemes {
            var vertices = scheme.vertices
            
            vertices = vertices.map{ scheme.hull.transform.apply($0) }
            
            let coordinates = scheme.coordinates
            let color = scheme.color
            
            var array: [Float] = []
            
            for i in 0 ..< vertices.count {
                array.appendContentsOf([
                    vertices[i].x,
                    vertices[i].y,
                    coordinates[i].x,
                    coordinates[i].y,
                    color.x,
                    color.y,
                    color.z,
                    color.w
                ])
            }
            
            compiled.appendContentsOf(array)
        }
        
        return compiled.asData()
    }
    
    func getIndicesArray() -> [UInt16] {
        var indices: [UInt16] = []
        
        for (index, scheme) in group.schemes.enumerate() {
            let raw = scheme.getRawScheme() as! RawVisualScheme
            indices.appendContentsOf(raw.getIndicesArray(index * 4))
            if index < group.schemes.count - 1 {
                indices.append(UInt16.max)
            }
        }
        
        index_count = Int32(indices.count)
        
        return indices
    }
    
    func getIndices() -> UnsafeMutablePointer<UInt16> {
        return getIndicesArray().asData()
    }
    
    func getCompiledBufferDataSize() -> Int32 {
        return Int32(amountOfNumbers * 6 * sizeof(Float))
    }
    
    func getIndexBufferSize() -> Int32 {
        return index_count * 2
    }
    
    var amountOfIndices: Int {
        return amountOfSides * 3
    }
    
    var amountOfSides: Int {
        var sum = 0
        group.schemes.forEach{ sum += $0.vertices.count }
        return sum
    }
    
    var amountOfNumbers: Int {
        return amountOfSides * 2
    }
    
    func getMatrix() -> GLKMatrix4 {
        return GLKMatrix4Rotate(GLKMatrix4MakeTranslation(0, 0, 0), 0, 0, 0, 1)
    }
    
    func getTexture() -> GLuint {
        return group.schemes[0].texture
    }
}



















