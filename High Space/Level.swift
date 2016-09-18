//
//  Level.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/11/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Level {
    var rooms: [Room]
    var current: Room!
    
    init() {
        rooms = []
    }
}

class Room {
    
    let size: float2
    let map: Map
    
    init(_ size: float2) {
        self.size = size
        map = Map(size)
    }
    
}

class Line {
    var first: float2
    var second: float2
    
    init(_ first: float2, _ second: float2) {
        self.first = first
        self.second = second
    }
    
    var midpoint: float2 {
        return (first + second) / 2
    }
    
    var vector: float2 {
        return second - first
    }
    
    var direction: float2 {
        return normalize(vector)
    }
    
    var normal: float2 {
        return -normalize(float2(vector.y, -vector.x))
    }
    
    var angle: Float {
        return atan2(vector.y, vector.x)
    }
    
    var length: Float {
        return vector.length
    }
    
    func translate(_ vector: float2) {
        first += vector
        second += vector
    }
    
    func intersects(other: Line) -> float2? {
        let p = float2(-vector.y, vector.x)
        let h = dot((first - other.first), p) / dot(other.vector, p)
        guard h > 0 && h < 1 else { return nil }
        return other.first + other.vector * h
    }
}

extension Line: CustomStringConvertible {
    var description: String {
        return "[(\(first)), (\(second))]"
    }
}

class RoomMap {
    
    let complexity: Int
    let size: float2
    
    var direction: float2
    var startPoint: float2
    
    var bitmap: [Int]
    var scale = 2.5.m
    
    init(_ complexity: Int, _ size: float2) {
        self.complexity = complexity
        self.size = size / scale
        startPoint = float2(0, 0)
        direction = float2(1, 0)
        bitmap = Array<Int>(repeating: 0, count: Int(self.size.x * self.size.y))
    }
    
    func generate() {
        for _ in 0 ..< complexity {
            let endPoint = startPoint + (computeMaxPoint() - startPoint) * random(0.4, 0.8)
            let line = Line(startPoint, endPoint)
            
            let dl = line.vector
            let count = Int(dl.length)
            
            for n in 0 ..< count {
                let point = line.first + Float(n) * line.direction
                setMap(point, value: 1)
            }
            
            startPoint = endPoint
            computeDirection(endPoint)
        }
    }
    
    func setMap(_ point: float2, value: Int) {
        let index = Int(point.x) + Int(-point.y * size.x)
        guard index >= 0 && index < Int(size.x * size.y) else { return }
        bitmap[index] = value
    }
    
    func computeDirection(_ endPoint: float2) {
        let ran = Float(arc4random() % 2 == 0 ? 1 : -1)
        direction = direction.x != 0 ? float2(0, ran) : float2(ran, 0)
        if direction.y != 0 {
            if endPoint.y == -size.y {
                direction = float2(0, 1)
            }
            if endPoint.y == 0 {
                direction = float2(0, -1)
            }
        }else{
            if endPoint.x == 0 {
                direction = float2(1, 0)
            }
            if endPoint.x == size.x {
                direction = float2(-1, 0)
            }
        }
    }
    
    func computeMaxPoint() -> float2 {
        var maxEndPoint = direction * size
        if direction.x == 0 {
            maxEndPoint.x = startPoint.x
        }else{
            maxEndPoint.y = startPoint.y
        }
        return maxEndPoint
    }
    
}

class RoomGenerator {
    
    func generate(_ map: RoomMap) -> Room {
        let room = Room(map.size * map.scale)
        
        for x in 0 ..< Int(map.size.x) {
            for y in 0 ..< Int(map.size.y) {
                let point = float2(Float(x) + 0.5, Float(y) - map.size.y + 0.5) * map.scale
                let index = x + Int(Float(y) * map.size.x)
                //print(x, y, index)
                if map.bitmap[index] == 0 {
                    let block = Structure(point, float2(map.scale))
                    room.map.append(block)
                }
            }
        }
        
        return room
    }
    
}













