//
//  SingleDisplayMethod.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SingleDisplayMethod: GraphicsMethod {
    var nodes: [RenderNode]
    
    init() {
        nodes = []
    }
    
    func create(_ info: GraphicsInfo) {
        if let material = info.material as? ClassicMaterial {
            let display = Display(info.hull, material)
            nodes.append(RenderNode(info, display))
        }
    }
    
    func clear() {}
    
    func update() {
        nodes = nodes.filter{ $0.handle.active }
        nodes = nodes.sorted{ $0.handle.material < $1.handle.material }
        for node in nodes {
            node.render.refresh()
        }
    }
    
    func render() {
        for node in nodes {
            node.render.render()
        }
    }
}
