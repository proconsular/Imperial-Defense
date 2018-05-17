//
//  GraphicsHelper.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class GraphicsHelper {
    static func setUniformMatrix(_ matrix: GLKMatrix4) {
        let m = GLKMatrix4Multiply(projectionMatrix, matrix)
        glUniformMatrix4fv(modelViewProjectionMatrix_Uniform, 1, 0, GLHelper.convert(m))
    }
}
