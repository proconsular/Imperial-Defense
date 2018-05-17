//
//  NodeIndex.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class NodeIndex: PropertyNodeDelegate {
    var groups: [RenderGroupNode]
    
    init() {
        groups = []
    }
    
    func inserted(_ node: PropertyRenderNode) {
        groups.append(RenderGroupNode(node))
    }
    
    func update() {
        for group in groups {
            group.update()
        }
        
        //groups = groups.sorted{ $0.order < $1.order }
    }
    
    func render() {
        for group in groups {
            group.render()
        }
    }
}
