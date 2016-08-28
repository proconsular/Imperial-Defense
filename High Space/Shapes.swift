//
//  FixedRect.swift
//  Relaci
//
//  Created by Chris Luttio on 9/15/14.
//  Copyright (c) 2014 FishyTale Digital, Inc. All rights reserved.
//


struct FixedRect {
    var location, halfbounds: float2
    
    init (_ location: float2, _ bounds: float2) {
        self.location = location
        self.halfbounds = bounds / 2
    }
    
    func contains (point: float2) -> Bool {
        return FixedRect.intersects(self, FixedRect(point, float2(1)))
    }
    
    static func intersects (prime: FixedRect, _ secunde: FixedRect) -> Bool {
        if abs(prime.location.x - secunde.location.x) > prime.halfbounds.x + secunde.halfbounds.x { return false }
        if abs(prime.location.y - secunde.location.y) > prime.halfbounds.y + secunde.halfbounds.y { return false }
        return true
    }
    
    var bounds: float2 {
        return halfbounds * 2
    }
}

class Sorter {
    static func sortVertices (vertices: [float2]) -> [float2] {
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
        
        return sortedVertices.reverse()
    }
    
    static func findNextHullIndex(vertices: [float2], _ hullVertex: float2, _ hullIndex: Int) -> Int {
        var nextIndex = 0
        for index in 1 ..< vertices.count {
            guard nextIndex != hullIndex else { nextIndex = index; continue }
            if isNextHullIndex(vertices[index] - hullVertex, vertices[nextIndex] - hullVertex) {
                nextIndex = index
            }
        }
        return nextIndex
    }
    
    static func isNextHullIndex(primary: float2, _ secondary: float2) -> Bool {
        let crossProduct = cross(secondary, primary).z
        return crossProduct < 0 || (crossProduct == 0 && primary.isGreaterThan(secondary))
    }
    
    static func findRightMostVertex(vertices: [float2]) -> Int {
        return findBestIndex(1 ..< vertices.count, -FLT_MAX, >) { vertices[$0].x }!
    }
}

