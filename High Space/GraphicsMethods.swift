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
    func clear()
    
    func update()
    func render()
}

class GraphicsInfo {
    var active: Bool
    let hull: Hull
    var materials: [Material]
    
    init(_ hull: Hull, _ material: Material) {
        self.hull = hull
        materials = []
        materials.append(material)
        active = true
    }
    
    var material: Material {
        get { return materials[0] }
        set { materials[0] = newValue }
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
    
    func clear() {
        
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

class SingleRendererMethod: GraphicsMethod {
    var renderers: [BaseRenderer]
    
    init() {
        renderers = []
    }
    
    func create(_ info: GraphicsInfo) {
        let renderer = BaseRenderer()
        renderer.append(info)
        renderer.compile()
        renderers.append(renderer)
    }
    
    func update() {
        for renderer in renderers {
            renderer.clean()
        }
        renderers = renderers.filter{ !$0.graphics.isEmpty }
        renderers = renderers.sorted{ ($0.graphics[0].material["order"] as! Int) < ($1.graphics[0].material["order"] as! Int) }
        renderers.forEach{ $0.update() }
    }
    
    func clear() {
        renderers.removeAll()
    }
    
    func render() {
        for renderer in renderers {
            let bounds = renderer.graphics[0].hull.getBounds()
            if Camera.current.contains(bounds) {
                renderer.render()
            }
        }
    }
    
}

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

protocol GraphicsRenderer {
    func append(_ info: GraphicsInfo)
    func compile()
    func update()
    func render()
}

class DisplayGroupRenderer: GraphicsRenderer {
    var renderers: [Display]
    
    init() {
        renderers = []
    }
    
    func append(_ info: GraphicsInfo) {
        renderers.append(Display(info.hull, info.material as! ClassicMaterial))
    }
    
    func compile() {
        
    }
    
    func update() {
        
    }
    
    func render() {
        for renderer in renderers {
            renderer.refresh()
            renderer.render()
        }
    }
    
}














