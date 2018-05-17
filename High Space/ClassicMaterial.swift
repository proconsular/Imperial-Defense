//
//  ClassicMaterial.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ClassicMaterial: Material {
    var texture: GLTexture
    var coordinates: [float2]
    var color: float4
    
    init(_ texture: GLTexture, _ color: float4 = float4(1)) {
        self.texture = texture
        self.color = color
        coordinates = [float2(0, 0), float2(1, 0), float2(1, 1), float2(0, 1)].rotate(3)
        super.init()
        
        self["shader"] = 0
        self["order"] = order
        self["texture"] = texture.id
        self["color"] = color
        //properties[findIndex("color")].sorted = false
    }
    
    convenience override init() {
        self.init(GLTexture(), float4(1))
    }
    
    func set(_ order: Int, _ texture: GLuint, _ coordinates: [float2]) {
        self["order"] = order
        self["texture"] = texture
        self.coordinates = coordinates
    }
    
    override func bind() {
        Graphics.bindDefault()
        glBindTexture(GLenum(GL_TEXTURE_2D), self["texture"] as! GLuint)
        GraphicsHelper.setUniformMatrix(GLKMatrix4MakeTranslation(Camera.current.transform.location.x, Camera.size.y, 0))
    }
}
