//
//  MatrixComputer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
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
