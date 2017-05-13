//
//  Animation.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/9/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol TextureLayout {
    var coordinates: [float2] { get }
}

class FlatIndex {
    
    var width: Int
    var height: Int
    
    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height
    }
    
    func getX(_ index: Int) -> Int {
        return index % width
    }
    
    func getY(_ index: Int) -> Int {
        return index / width
    }
    
    func getIndex(_ x: Int, _ y: Int) -> Int {
        return x + y * width
    }
    
}

class FlatIndexer {
    
    var index: Int
    var mapper: FlatIndex
    
    init(_ index: Int, _ width: Int, _ height: Int) {
        self.index = index
        mapper = FlatIndex(width, height)
    }
    
    var x: Int {
        get { return mapper.getX(index) }
        set { index = mapper.getIndex(newValue, y) }
    }
    
    var y: Int {
        get { return mapper.getY(index) }
        set { index = mapper.getIndex(x, newValue) }
    }
    
    func set(_ x: Int, _ y: Int) {
        index = mapper.getIndex(x, y)
    }
    
    var width: Int {
        return mapper.width
    }
    
    var height: Int {
        return mapper.height
    }
    
}

class SheetLayout: FlatIndexer, TextureLayout {
    
    var coordinates: [float2] {
        let frame = float2(1 / Float(width), 1 / Float(height))
        let location = float2(Float(x), Float(y)) * frame
        return [location, float2(location.x, location.y + frame.y), location + frame, float2(location.x + frame.x, location.y)]
    }
   
}

class SheetAnimation: FlatIndexer {
    
    var offset, length: Int
    
    init(_ offset: Int, _ length: Int, _ width: Int, _ height: Int) {
        self.offset = offset
        self.length = length
        super.init(0, width, height)
    }
    
    func animate() {
        index = (index + 1) % length
    }
    
    var frame: Int {
        return index + offset
    }
    
}

class ActiveList<Object> {
    
    var list: [Object]
    var index: Int
    
    init(_ list: [Object]) {
        self.list = list
        index = 0
    }
    
    var current: Object {
        return list[index]
    }
    
    func append(_ object: Object) {
        list.append(object)
    }
    
}

protocol Animation {
    var frame: Int { get }
    var coordinates: [float2] { get }
    func animate()
}

class TextureAnimator: ActiveList<SheetAnimation>, TextureLayout, Animation {
    
    var sheet: SheetLayout
    
    init(_ sheet: SheetLayout) {
        self.sheet = sheet
        super.init([])
    }
    
    func animate() {
        current.animate()
    }
    
    func set(_ index: Int) {
        self.index = index
    }
    
    func update() {
        sheet.index = current.frame
    }
    
    var coordinates: [float2] {
        update()
        return sheet.coordinates
    }
    
    var frame: Int {
        return current.frame
    }
    
}














