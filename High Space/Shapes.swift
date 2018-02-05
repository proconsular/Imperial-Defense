//
//  FixedRect.swift
//  Relaci
//
//  Created by Chris Luttio on 9/15/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//


struct FixedRect {
    var location, halfbounds: float2
    
    init (_ location: float2, _ bounds: float2) {
        self.location = location
        self.halfbounds = bounds / 2
    }
    
    func contains (_ point: float2) -> Bool {
        return FixedRect.intersects(self, FixedRect(point, float2(2)))
    }
    
    static func intersects (_ prime: FixedRect, _ secunde: FixedRect) -> Bool {
        if abs(prime.location.x - secunde.location.x) > prime.halfbounds.x + secunde.halfbounds.x { return false }
        if abs(prime.location.y - secunde.location.y) > prime.halfbounds.y + secunde.halfbounds.y { return false }
        return true
    }
    
    func intersects(_ other: FixedRect) -> Bool {
        return FixedRect.intersects(self, other)
    }
    
    var bounds: float2 {
        get { return halfbounds * 2 }
        set { halfbounds = newValue / 2 }
    }
}

class Sorter {
    static func sortVertices (_ vertices: [float2]) -> [float2] {
        var sortedVertices: [float2] = []
        
        let rightIndex = findRightMostVertex(vertices)
        var hull = [Int] ()
        var hullIndex = rightIndex
        
        var index = 0
        while true {
            hull.append(hullIndex)
            sortedVertices.append(vertices[hullIndex])
            hullIndex = findNextHullIndex(vertices, vertices[hull[index]], hullIndex)
            guard hullIndex != rightIndex else { break }
            index += 1
        }
        
        return sortedVertices.reversed()
    }
    
    static func findNextHullIndex(_ vertices: [float2], _ hullVertex: float2, _ hullIndex: Int) -> Int {
        var nextIndex = 0
        for index in 1 ..< vertices.count {
            guard nextIndex != hullIndex else { nextIndex = index; continue }
            if isNextHullIndex(vertices[index] - hullVertex, vertices[nextIndex] - hullVertex) {
                nextIndex = index
            }
        }
        return nextIndex
    }
    
    static func isNextHullIndex(_ primary: float2, _ secondary: float2) -> Bool {
        let crossProduct = cross(secondary, primary).z
        return crossProduct < 0 || (crossProduct == 0 && primary.isGreaterThan(secondary))
    }
    
    static func findRightMostVertex(_ vertices: [float2]) -> Int {
        return findBestIndex(1 ..< vertices.count, -Float.greatestFiniteMagnitude, >) { vertices[$0].x }!
    }
}

