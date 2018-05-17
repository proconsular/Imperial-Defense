//
//  RenderNode.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RenderNode {
    let handle: GraphicsInfo
    let render: Render
    
    init(_ handle: GraphicsInfo, _ render: Render) {
        self.handle = handle
        self.render = render
    }
}
