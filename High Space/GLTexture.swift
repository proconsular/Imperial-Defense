//
//  GLTexture.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/27/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GLTexture {
    var id: GLuint
    
    init(_ name: String = "white") {
        id = GLTextureLibrary.shared().texture(withName: name)
    }
    
    init (_ id: GLuint) {
        self.id = id
    }
}
