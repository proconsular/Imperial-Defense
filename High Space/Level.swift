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
    var index: Int = 0
    
    var dreathmap: DreathMap!
    
    let depth: Int
    
    init(_ depth: Int) {
        self.depth = depth
        rooms = []
        rooms.append(createRoom(float2(), float2(1, 0)))
        current = rooms[0]
        
        Camera.bounds = current.size
        
        dreathmap = DreathMap(self)
    }
    
    func createRoom(_ start: float2, _ direction: float2) -> Room {
        let map = RoomMap(14, float2(30.m))
        map.setStart(start, direction)
        map.generate()
        let gen = RoomGenerator()
        return gen.generate(map)
    }
    
    func findOpenedDoor(actor: Actor) -> Door? {
        for door in current.doors {
            if FixedRect.intersects(door.body.shape.getBounds(), actor.body.shape.getBounds()) {
                return door
            }
        }
        return nil
    }
    
    func openDoor() {
        if let door = findOpenedDoor(actor: Player.player) {
            if door.room >= 0 {
                changeRoom(index: door.room, rooms[door.room].findDoor(index)!)
            }else{
                if depth == 0 || rooms.count - 1 < depth {
                    let direction = -door.direction
                    let start = float2(direction == 1 ? 0 : 9, 0)
                    let other_door = tryRoom(start, -direction)
                    door.room = rooms.count - 1
                    changeRoom(index: door.room, other_door)
                }
            }
        }
    }
    
    func tryRoom(_ start: float2, _ direction: Int) -> Door {
        let room = createRoom(start, float2(Float(-direction), 0))
        if let door = getDoor(room, -direction) {
            rooms.append(room)
            return door
        }else{
            return tryRoom(start, direction)
        }
    }
    
    func getDoor(_ room: Room, _ direction: Int) -> Door? {
        return room.findDoor(self.index) ?? room.getDoor(float2(Float(direction), 0))
    }
    
    func changeRoom(index: Int, _ other_door: Door) {
        let actor = Player.player!
        current.map.remove(actor)
        
        let last = self.index
        
        current = rooms[index]
        self.index = index
        
        Camera.bounds = current.size
        
        other_door.room = last
        
        actor.transform.location = float2(other_door.transform.location.x + Float(other_door.direction) * 2.m, other_door.transform.location.y)
        
        Camera.transform.location = actor.transform.location
        
        current.map.append(actor)
    }
    
    func update() {
        openDoor()
        dreathmap.update()
        current.update()
    }
    
    func render() {
        current.render()
    }
}

class Room {
    
    let size: float2
    let map: Map
    
    let physics: Simulation
    let lighting: LightingSystem
    
    var doors: [Door]
    
    init(_ size: float2) {
        self.size = size
        map = Map(size)
        doors = []
        lighting = LightingSystem(map.grid)
        physics = Simulation(map.grid)
    }
    
    func getDoor(_ direction: float2) -> Door? {
        for door in doors {
            if door.direction == Int(direction.x) {
                return door
            }
        }
        return nil
    }
    
    func findDoor(_ index: Int) -> Door? {
        for door in doors {
            if door.room == index {
                return door
            }
        }
        return nil
    }
    
    func update() {
        map.update()
        physics.simulate()
        Camera.update()
    }
    
    func render() {
        map.render()
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
    var scale = 3.m
    
    init(_ complexity: Int, _ size: float2) {
        self.complexity = complexity
        self.size = size / scale
        startPoint = float2()
        direction = float2(1, 0)
        bitmap = Array<Int>(repeating: 0, count: Int(self.size.x * self.size.y))
    }
    
    func setStart(_ location: float2, _ direction: float2) {
        self.startPoint = location
        self.direction = direction
    }
    
    func generate() {
        for _ in 0 ..< complexity {
            let endPoint = startPoint + (computeMaxPoint() - startPoint) * 0.5
            let line = Line(startPoint, endPoint)
            
            let count = Int(ceil(line.length))
            
            for n in 0 ..< count {
                let point = line.first + Float(n) * line.direction
                setMap(point, 1)
            }
            
            startPoint = endPoint
            computeDirection(endPoint)
        }
    }
    
    func setMap(_ point: float2, _ value: Int) {
        let index = Int(point.x) + Int(-point.y * size.x)
        guard contains(index: index) else { return }
        bitmap[index] = value
    }
    
    func getIndex(_ x: Int, _ y: Int) -> Int {
        return x + Int(Float(y) * size.x)
    }
    
    func getPoint(_ x: Int, _ y: Int) -> float2 {
        return float2(Float(x) + 0.5, Float(y) - size.y + 0.5) * scale
    }
    
    func contains(index: Int) -> Bool {
        return index >= 0 && index < Int(size.x * size.y)
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
        var maxEndPoint = float2(clamp(direction.x * size.x, min: 0, max: size.x), -clamp(-direction.y * size.y, min: 0, max: size.y))
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
                let point = map.getPoint(x, y)
                let index = map.getIndex(x, y)
                if map.bitmap[index] == 0 {
                    let block = Structure(point, float2(map.scale))
                    let tint = random(0.1, 0.3)
                    block.display.color = float4(tint + random(0, 0.1), tint, tint, 1)
                    block.display.texture = GLTexture("rock").id
                    room.map.append(block)
                }
                if map.bitmap[index] == 1 {
                    let index_below = map.getIndex(x, y + 1)
                    let point_below = map.getPoint(x, y + 1)
                    
                    if map.contains(index: index_below) {
                        if map.bitmap[index_below] == 0 {
                            let direction = point_below.x <= map.scale / 2 ? 1 : -1
                            if point_below.x <= map.scale / 2 || point_below.x >= map.size.x * map.scale - map.scale / 2 {
                                let index_side = map.getIndex(x + direction, y)
                                
                                if map.contains(index: index_side) {
                                    if map.bitmap[index_side] == 1 {
                                        let block = Door(point, float2(map.scale), direction)
                                        room.map.append(block)
                                        room.doors.append(block)
                                    }
                                }
                                
                            }
                        }
                       
                    }
                    
                }
            }
        }
        
        return room
    }
    
}













