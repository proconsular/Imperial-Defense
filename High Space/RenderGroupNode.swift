//
//  RenderGroupNode.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class RenderGroupNode: PropertyNodeListener {
    let node: PropertyRenderNode
    let renderer: BaseRenderer
    var order: Int = 0
    
    init(_ node: PropertyRenderNode) {
        self.node = node
        renderer = BaseRenderer()
        node.listener = self
    }
    
    func appeneded(_ info: GraphicsInfo) {
        renderer.append(info)
        order = info.material["order"] as! Int
        renderer.compile()
    }
    
    func removed(_ info: GraphicsInfo) {
        for i in 0 ..< renderer.graphics.count {
            if renderer.graphics[i] === info {
                renderer.graphics.remove(at: i)
                break
            }
        }
        renderer.compile()
    }
    
    func update() {
        renderer.update()
    }
    
    func render() {
        renderer.render()
    }
}
