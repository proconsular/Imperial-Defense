//
//  RenderFactory.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/28/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicsMethod {
    func create(_ info: GraphicsInfo) -> RenderHandle!
    
    func update()
    func render()
}

class GraphicsInfo {
    let hull: Hull
    let material: Material
    
    init(_ hull: Hull, _ material: Material) {
        self.hull = hull
        self.material = material
    }
    
}

class RenderHandle {
    var alive: Bool
    var info: GraphicsInfo
    
    init(_ info: GraphicsInfo) {
        self.info = info
        alive = true
    }
    
    func destroy() {
        alive = false
    }
}

class RenderNode {
    let handle: RenderHandle
    let render: Render
    
    init(_ handle: RenderHandle, _ render: Render) {
        self.handle = handle
        self.render = render
    }
}

class SingleDisplayMethod: GraphicsMethod {
    
    var nodes: [RenderNode]
    
    init() {
        nodes = []
    }
    
    func create(_ info: GraphicsInfo) -> RenderHandle! {
        if let material = info.material as? ClassicMaterial {
            let display = Display(info.hull, material)
            let handle = RenderHandle(info)
            nodes.append(RenderNode(handle, display))
            return handle
        }
        return nil
    }
    
    func update() {
        nodes = nodes.filter{ $0.handle.alive }
        nodes = nodes.sorted{ $0.handle.info.material < $1.handle.info.material }
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

class SortedRendererMethod: GraphicsMethod {
    
    var index: RenderTree
    
    init() {
        index = RenderTree()
    }
    
    func create(_ info: GraphicsInfo) -> RenderHandle! {
        let handle = RenderHandle(info)
        index.append(handle)
        return handle
    }
    
    func update() {
        
    }
    
    func render() {
        
    }
    
}

class RenderTree {
    
    var root: TreeNode
    
    init() {
        root = TreeNode("")
    }
    
    func append(_ node: RenderHandle) {
        let properties = node.info.material.properties
        for node in root.nodes {
            
        }
    }
    
}

class TreeNode {
    
    var property: String
    
    var nodes: [TreeNode]
    
    init(_ property: String) {
        self.property = property
        nodes = []
    }
    
}




















