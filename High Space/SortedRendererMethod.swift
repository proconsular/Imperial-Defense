//
//  SortedRendererMethod.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SortedRendererMethod: GraphicsMethod {
    var rootNode: PropertyRenderNode
    var nodeIndex: NodeIndex
    
    init() {
        rootNode = PropertyRenderNode()
        nodeIndex = NodeIndex()
        
        PropertyRenderNode.delegate = nodeIndex
        PropertyRenderNode.root = rootNode
        
        let node = PropertyRenderNode(MaterialValue("shader", 0))
        //        node.organizer = DrawOrderOrganizer(node)
        rootNode.nodes.append(node)
    }
    
    func create(_ info: GraphicsInfo) {
        rootNode.insert(info)
    }
    
    func clear() {
        
    }
    
    func update() {
        rootNode.clean()
        nodeIndex.update()
    }
    
    func render() {
        nodeIndex.render()
    }
}
