//
//  Map.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/12/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Map {
    
    let size: float2
    let grid: Grid
    var actors: [Actor]
    
    init(_ size: float2) {
        self.size = size
        actors = []
        grid = Grid(10.m, size)
    }
    
    func append(_ element: Actor) {
        actors.append(element)
        grid.append(element)
    }
    
    func update() {
        updateObjects()
        grid.update()
        clean()
    }
    
    private func updateObjects() {
        actors.forEach {
            $0.update()
            $0.onObject = false
        }
    }
    
    private func clean() {
        actors = actors.filter{ $0.alive }
    }
    
    func render() {
        actors.sorted{ $0.order < $1.order }.forEach{
            //if Camera.visible($0.transform.location) {
            $0.render()
            //}
        }
    }
    
}
