//
//  RawSchemeGroup.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

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
                array.append(contentsOf: [
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
            
            compiled.append(contentsOf: array)
        }
        
        return compiled.asData()
    }
    
    func getIndicesArray() -> [UInt16] {
        var indices: [UInt16] = []
        
        for (index, scheme) in group.schemes.enumerated() {
            let raw = scheme.getRawScheme() as! RawVisualScheme
            indices.append(contentsOf: raw.getIndicesArray(index * 4))
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
        return Int32(amountOfNumbers * 6 * MemoryLayout<Float>.size)
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


