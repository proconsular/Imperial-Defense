//
//  IndexBuffer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class IndexBuffer: Buffer<UInt16> {
    init(_ data: [UInt16]) {
        super.init(GLenum(GL_ELEMENT_ARRAY_BUFFER), data, GLenum(GL_STATIC_DRAW))
    }
}
