//
//  Material.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Material: Comparable {
    var shader: Int
    var order: Int
    
    var properties: [MaterialValue]
    var dirty = false
    
    init() {
        shader = 0
        order = 0
        properties = []
    }
    
    subscript(name: String) -> Any {
        get {
            return find(name).value
        }
        set {
            if var p = find(name) {
                p.value = newValue
                properties[findIndex(name)] = p
                dirty = true
            }else{
                properties.append(MaterialValue(name, newValue))
            }
        }
    }
    
    func find(_ name: String) -> MaterialValue! {
        for property in properties {
            if property.name == name {
                return property
            }
        }
        return nil
    }
    
    func findIndex(_ name: String) -> Int! {
        for i in 0 ..< properties.count {
            if properties[i].name == name {
                return i
            }
        }
        return nil
    }
    
    func bind() {
        
    }
}
