//
//  Rendering.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/18/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BaseRenderer: GraphicsRenderer {
    var graphics: [GraphicsInfo]
    
    let array: VertexArray
    var buffer: GraphicsBuffer!
    
    init() {
        graphics = []
        array = VertexArray()
        array.bind()
        VertexArray.enableAttribute(.position)
        VertexArray.enableAttribute(.texCoord0)
        VertexArray.enableAttribute(.color)
    }
    
    func append(_ info: GraphicsInfo) {
        graphics.append(info)
    }
    
    func append(_ infos: [GraphicsInfo]) {
        graphics.append(contentsOf: infos)
    }
    
    func compile() {
        array.bind()
        buffer = GraphicsBuffer(graphics)
        VertexArray.enableAttributes()
    }
    
    func update() {
        clean()
        refresh()
    }
    
    func refresh() {
        buffer.refresh()
    }
    
    func clean() {
        var changed = false
        graphics = graphics.filter{
            if !$0.active { changed = true }
            return $0.active
        }
        if changed {
            compile()
        }
    }
    
    func bind() {
        if graphics.count > 0 {
            let material = graphics[0].material
            Texture.bind(material["texture"])
            GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(0, Camera.size.y, 0))
        }
    }
    
    func render() {
        bind()
        if (buffer) != nil {
            array.bind()
            draw()
        }
    }
    
    func draw() {
        glDrawElements(GLenum(GL_TRIANGLE_FAN), GLsizei(buffer.buffer.elements.data.count), GLenum(GL_UNSIGNED_SHORT), nil)
    }
    
}

class GraphicsHelper {
    
    static func setUniformMatrix(_ matrix: GLKMatrix4) {
        let m = GLKMatrix4Multiply(projectionMatrix, matrix)
        glUniformMatrix4fv(modelViewProjectionMatrix_Uniform, 1, 0, GLHelper.convert(m))
    }
    
}

class GraphicsBuffer {
    var data: [GraphicsInfo]
    var buffer: BufferSet
    
    init(_ data: [GraphicsInfo]) {
        self.data = data
        
        var indices: [UInt16] = []
        var vertices: [Float] = []
        
        var count = 0
        
        for info in data {
            var newIndices: [UInt16] = []
            var i = 0
            
            if info.hull is Shape<Edgeform> {
                newIndices = PolygonIndexer().computeIndices(info.hull.getVertices().count)
                i = info.hull.getVertices().count
            }else{
                newIndices = DividedPolygonIndexer().computeIndices(Radialform.divides)
                i = Radialform.divides
            }
            
            indices += newIndices.map{ $0 + UInt16(count) } + [UInt16.max]
            
            vertices += GraphicsInfoCompiler(info).compile()
            count += i
        }
        
        buffer = BufferSet(indices, vertices)
    }
    
    func refresh() {
        var compiledData: [Float] = []
        for info in data {
            compiledData += GraphicsInfoCompiler(info).compile()
        }
        buffer.vertices.upload(compiledData)
    }
}












