//
//  GraphicData.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class MatrixComputer {
    
    static func compute(_ transform: Transform) -> GLKMatrix4 {
        let global = transform.global
        let local = transform
        var location = global.location
        let orientation = global.orientation
        let translation = GLKMatrix4MakeTranslation(location.x, location.y, 0);
        let scale = GLKMatrix4MakeScale(local.scale.x, local.scale.y, 1)
        let rotation = GLKMatrix4MakeRotation(orientation, 0, 0, 1)
        let ts = GLKMatrix4Multiply(scale, translation)
        let tsr = GLKMatrix4Multiply(ts, rotation)
        return tsr
    }
    
}

class VertexInfo {
    let scheme: VisualScheme
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
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
    
    var bufferSize: Int32 {
        return Int32(amountOfNumbers * 6 * MemoryLayout<Float>.size)
    }
    
}

protocol GraphicDataCompiler {
    func compile() -> [Float]
}

class SchemeCompiler: GraphicDataCompiler {
    
    let scheme: VisualScheme
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
    }
    
    func compile() -> [Float] {
        var compiled: [Float] = []
        
        let vertices = scheme.vertices
        let coordinates = scheme.coordinates
        let color = scheme.color
        
        for i in 0 ..< vertices.count {
            compiled.append(contentsOf: [vertices[i].x, vertices[i].y, coordinates[i].x, coordinates[i].y, color.x, color.y, color.z, color.w])
        }
        
        return compiled
    }
    
}

class GraphicsInfoCompiler: GraphicDataCompiler {
    let info: GraphicsInfo
    
    init(_ info: GraphicsInfo) {
        self.info = info
    }
    
    func compile() -> [Float] {
        var compiled: [Float] = []
        
        let vertices = info.hull.getVertices()
        let material = info.material as! ClassicMaterial
        let coordinates = material.coordinates
        let color = info.material["color"] as! float4
        
        for i in 0 ..< vertices.count {
            compiled.append(contentsOf: [vertices[i].x, vertices[i].y, coordinates[i].x, coordinates[i].y, color.x, color.y, color.z, color.w])
        }
        
        return compiled
    }
    
}


















