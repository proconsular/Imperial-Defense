//
//  PointMaterial.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class PointMaterial: Material {
    override init() {
        super.init()
        
        self["color"] = float4(1)
    }
    
    override func bind() {
        let _ = Graphics.bind(5)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
}
