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
        let map = RoomMap(20, float2(30.m))
        map.setStart(start, direction)
        map.generate()
        let gen = RoomGenerator(map)
        if rooms.count > depth - 1 {
            gen.hasGoal = true
        }
        return gen.generate()
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
                    let amount = Float(10 * (rooms.count - 1))
                    dreathmap.spawn(amount)
                }
            }
        }
    }
    
    func tryRoom(_ start: float2, _ direction: Int) -> Door {
        let room = createRoom(start, float2(Float(-direction), 0))
        if let door = getDoor(room, -direction), room.doors.count >= 3 {
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
        
        let act_size = actor.body.shape.getBounds().bounds
        let door_size = other_door.body.shape.getBounds().bounds
        
        actor.transform.location = float2(other_door.transform.location.x + Float(other_door.direction) * 0.5.m, other_door.transform.location.y + door_size.y / 2 - act_size.y / 2)
        
        Camera.transform.location = actor.transform.location - Camera.size / 2
        
        current.map.append(actor)
        
        play("door1")
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
        
        map.append(Structure(float2(size.x / 2, 0), float2(size.x, 0.1.m)))
        map.append(Structure(float2(size.x / 2, -size.y), float2(size.x, 0.1.m)))
        map.append(Structure(float2(0, -size.y / 2), float2(0.1.m, size.y)))
        map.append(Structure(float2(size.x, -size.y / 2), float2(0.1.m, size.y)))
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
            let endPoint = floor(startPoint) + (computeMaxPoint() - startPoint) * 0.5
            let line = Line(floor(startPoint), floor(endPoint))
            
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
    
    var map: RoomMap!
    var room: Room!
    var x: Int = 0
    var y: Int = 0
    var point: float2 = float2()
    var index: Int = 0
    var hasGoal = false
    
    init(_ map: RoomMap) {
        self.map = map
    }
    
    func generate() -> Room {
        room = Room(map.size * map.scale)
        
        x = 0
        y = 0
        index = 0
        point = float2()
        
        for x in 0 ..< Int(map.size.x) {
            self.x = x
            for y in 0 ..< Int(map.size.y) {
                self.y = y
                point = map.getPoint(x, y)
                index = map.getIndex(x, y)
                makeBlock()
                makeObjectAbove()
                
            }
        }
        
        return room
    }
    
    func makeBlock() {
        if map.bitmap[index] == 0 {
            let block = Structure(point, float2(map.scale))
            let tint = random(0.1, 0.3)
            block.display.color = float4(tint + random(0, 0.1), tint, tint, 1)
            block.display.texture = GLTexture("rock").id
            room.map.append(block)
        }
    }
    
    func makeObjectAbove() {
        if map.bitmap[index] == 1 {
            let index_below = map.getIndex(x, y + 1)
            let point_below = map.getPoint(x, y + 1)
            if map.contains(index: index_below) {
                if map.bitmap[index_below] == 0 {
                    makeObject(point_below)
                }
            }
        }
    }
    
    func makeObject(_ point_below: float2) {
        if isOnEdge(point_below) {
            makeDoor(point_below)
        }else{
            if hasGoal {
                hasGoal = false
                makeGoal()
            }else{
                if random(0, 1) < 0.7 {
                   makeGem()
                }else if random(0, 1) < 0.2 {
                    let goal = Forge(float2(point.x, point.y))
                    room.map.append(goal)
                }
            }
        }
    }
    
    func makeGem() {
        let size = float2(0.3.m, 0.3.m)
        var array: [Int] = []
        for _ in 0 ..< 6 {
            array.append(Int(arc4random() % 2))
        }
        let id = Gem.Identity(array)
        let goal = Gem(float2(point.x, point.y + map.scale / 2 - size.y / 2), id)
        
        room.map.append(goal)
    }
    
    func makeGoal() {
        let size = float2(0.4.m, 0.5.m)
        let goal = Structure(float2(point.x, point.y + map.scale / 2 - size.y / 2), size)
        goal.display.color = float4(1, 1, 0.8, 1)
        goal.body.tag = "goal"
        goal.display.texture = GLTexture("book").id
        room.map.append(goal)
    }
    
    func isOnEdge(_ point: float2) -> Bool {
        return point.x <= map.scale / 2 || point.x >= map.size.x * map.scale - map.scale / 2
    }
    
    func makeDoor(_ point_below: float2) {
        let direction = point_below.x <= map.scale / 2 ? 1 : -1
        let index_side = map.getIndex(x + direction, y)
        if map.contains(index: index_side) {
            if map.bitmap[index_side] == 1 {
                let size = float2(0.5.m, map.scale / 2)
                let offset = -map.scale / 2 + size.x / 2
                let dir = float2(Float(direction) * offset, map.scale / 2 - size.y / 2)
                let block = Door(point + dir, size, direction)
                room.map.append(block)
                room.doors.append(block)
            }
        }
    }
    
}













