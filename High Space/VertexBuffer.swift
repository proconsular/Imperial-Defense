//
//  VertexBuffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class VertexBuffer: Buffer<Float> {
    init(_ data: [Float]) {
        super.init(GLenum(GL_ARRAY_BUFFER), data, GLenum(GL_DYNAMIC_DRAW))
    }
}
