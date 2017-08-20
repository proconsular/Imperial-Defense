//
//  RenderFactory.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicsMethod {
    func create(_ info: GraphicsInfo)
    
    func update()
    func render()
}

class GraphicsInfo {
    var active: Bool
    let hull: Hull
    let material: Material
    
    init(_ hull: Hull, _ material: Material) {
        self.hull = hull
        self.material = material
        active = true
    }
}

class RenderNode {
    let handle: GraphicsInfo
    let render: Render
    
    init(_ handle: GraphicsInfo, _ render: Render) {
        self.handle = handle
        self.render = render
    }
}

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

class NodeIndex: PropertyNodeDelegate {
    var groups: [RenderGroupNode]
    
    init() {
        groups = []
    }
    
    func inserted(_ node: PropertyRenderNode) {
        groups.append(RenderGroupNode(node))
    }
    
    func render() {
        for group in groups {
            group.render()
        }
    }
}

class SortedRendererMethod: GraphicsMethod {
    var rootNode: PropertyRenderNode
    var nodeIndex: NodeIndex
    
    init() {
        rootNode = PropertyRenderNode()
        nodeIndex = NodeIndex()
        PropertyRenderNode.delegate = nodeIndex
    }
    
    func create(_ info: GraphicsInfo) {
        rootNode.insert(info)
    }
    
    func update() {
        rootNode.clean()
    }
    
    func render() {
        nodeIndex.render()
    }
}

class RenderGroupNode: PropertyNodeListener {
    let node: PropertyRenderNode
    var renderer: GroupRenderer!
    
    init(_ node: PropertyRenderNode) {
        self.node = node
        renderer = DisplayGroupRenderer()
        node.listener = self
    }
    
    func appeneded(_ info: GraphicsInfo) {
        renderer.append(info)
    }
    
    func update() {
        
    }
    
    func render() {
        renderer.render()
    }
    
}

protocol GroupRenderer {
    func append(_ info: GraphicsInfo)
    func render()
}

class DisplayGroupRenderer: GroupRenderer {
    var renderers: [Display]
    
    init() {
        renderers = []
    }
    
    func append(_ info: GraphicsInfo) {
        renderers.append(Display(info.hull, info.material as! ClassicMaterial))
    }
    
    func render() {
        for renderer in renderers {
            renderer.refresh()
            renderer.render()
        }
    }
    
}













