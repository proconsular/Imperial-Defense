//
//  RawScheme.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

@objc
class RawVisualScheme: NSObject, RawScheme {
    let scheme: VisualScheme
    let compiler: GraphicDataCompiler
    let info: VertexInfo
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
        compiler = SchemeCompiler(scheme)
        info = VertexInfo(scheme)
    }
    
    func getCompiledBufferData() -> UnsafeMutablePointer<Float> {
        return compiler.compile().asData()
    }
    
    func getCompiledBufferDataSize() -> Int32 {
        return info.bufferSize
    }
    
    func getIndicesArray(_ offset: Int = 0) -> [UInt16] {
        var indices: [UInt16] = []
        
        var indexer: GraphicIndexer
        
        if scheme.hull is Circle {
            indexer = DividedPolygonIndexer()
            let circle = scheme.hull as! Circle
            indices.append(contentsOf: indexer.computeIndices(Radialform.divides))
        }else{
            indexer = PolygonIndexer()
            indices.append(contentsOf: indexer.computeIndices(info.amountOfSides))
        }
        
        return indices.map{ $0 + UInt16(offset) }
    }
    
    func getIndices() -> UnsafeMutablePointer<UInt16> {
        return getIndicesArray().asData()
    }
    
    func getIndexBufferSize() -> Int32 {
        if let circle = scheme.hull as? Circle {
            return Int32(Radialform.divides * 6)
        }
        return Int32(info.amountOfIndices)
    }
    
    func getMatrix() -> GLKMatrix4 {
        return MatrixComputer.compute(scheme.hull.transform)
    }
    
    func getTexture() -> GLuint {
        return scheme.texture
    }
    
}






















