//
//  Sorting.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/16/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class SortingTester {
    
    init() {
        let node = PropertyRenderNode()
        let index = NodeIndex()
        PropertyRenderNode.delegate = index
        PropertyRenderNode.root = node
        
        var values: [GraphicsInfo] = []
        
        for _ in 0 ..< 10 {
            let material = ClassicMaterial(GLTexture())
            
            let value1 = GraphicsInfo(Rect(float2(300), float2(1.m)), material)
            
            values.append(value1)
            node.insert(value1)
        }
        
        //node.nodes[0].organizer = DrawOrderOrganizer(node)
        
        print(node.describe())
        
        values[0].material["order"] = 3
        values[1].material["texture"] = 3
        values[2].material["order"] = 1
        values[3].material["texture"] = 4
        values[4].material["color"] = float4(0)
        values[5].material["color"] = float4(0.5)
        
        node.clean()
        
        print(node.describe())
        
    }
    
    func update() {
        
    }
    
    func render() {
        
    }
    
}

func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool? {
    guard let a = a as? T, let b = b as? T else { return nil }
    return a == b
}

protocol PropertyNodeDelegate {
    func inserted(_ node: PropertyRenderNode)
}

protocol PropertyNodeListener {
    func appeneded(_ info: GraphicsInfo)
    func removed(_ info: GraphicsInfo)
}

protocol PropertyNodeOrganizer {
    func organize()
}

class DrawOrderOrganizer: PropertyNodeOrganizer {
    
    unowned let node: PropertyRenderNode
    
    init(_ node: PropertyRenderNode) {
        self.node = node
    }
    
    func organize() {
        node.nodes = node.nodes.sorted{ ($0.property.value as! Int) > ($1.property.value as! Int) }
    }
    
}

class PropertyRenderNode {
    
    static var delegate: PropertyNodeDelegate? = nil
    static var root: PropertyRenderNode!
    
    var listener: PropertyNodeListener?
    var organizer: PropertyNodeOrganizer?
    
    var property: MaterialValue
    var info: GraphicsInfo?
    
    var nodes: [PropertyRenderNode]
    
    init(_ pair: MaterialValue, _ info: GraphicsInfo? = nil) {
        property = pair
        self.info = info
        nodes = []
    }
    
    convenience init() {
        self.init(MaterialValue("", 0))
    }
    
    func clean() {
        for node in nodes {
            node.clean()
        }
        var rejects: [GraphicsInfo] = []
        nodes = nodes.filter {
            if let info = $0.info {
                if info.material.dirty {
                    rejects.append(info)
                    return false
                }
                return info.active
            }
            return $0.nodes.count > 0
        }
        
        for info in rejects {
            info.material.dirty = false
            listener?.removed(info)
            PropertyRenderNode.root.insert(info)
        }
        
        //organizer?.organize()
    }
    
    func insert(_ info: GraphicsInfo, _ depth: Int = 0) {
        let property = info.material.properties[depth]
        guard property.sorted else {
            nodes.append(PropertyRenderNode(property, info))
            listener?.appeneded(info)
            return
        }
        for node in nodes {
            if property == node.property {
                if depth + 1 < info.material.properties.count {
                    node.insert(info, depth + 1)
                    return
                }else{
                    node.nodes.append(PropertyRenderNode(property, info))
                    node.listener?.appeneded(info)
                    return
                }
            }
        }
        if depth + 1 < info.material.properties.count {
            let node = PropertyRenderNode(property)
            node.insert(info, depth + 1)
            nodes.append(node)
        }else{
            let node = PropertyRenderNode(property)
            node.nodes.append(PropertyRenderNode(property, info))
            nodes.append(node)
            PropertyRenderNode.delegate?.inserted(node)
            node.listener?.appeneded(info)
        }
    }
    
    func describe(_ depth: Int = 0) -> String {
        var output = ""
        
        var tab = ""
        for _ in 0 ..< depth {
            tab += "\t"
        }
        
        if let i = info {
            let material = i.material
            output += tab
            for p in material.properties {
                 output += p.name + ": \(p.value), "
            }
        }else{
            output += tab + property.name + ": \(property.value)"
            
            if nodes.count > 0 {
                output += " {\n"
                
                for n in 0 ..< nodes.count {
                    output += "\t" + nodes[n].describe(depth + 1) + "\n"
                }
                
                output += tab + "\t" + "}\n"
            }
        }
       
        return output
    }
    
}



















