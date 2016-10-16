//
//  Creator.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/11/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Maker<Product> {
    func make(_ offset: Float) -> Product! { return nil }
}


class MakerAttachment<Product> {
    func make(_ structure: Structure) -> Product? { return nil }
}

class FloorMaker: Maker<Structure> {
    
    override func make(_ offset: Float) -> Structure! {
        let size = float2(10.m, random(1.m, 2.m))
        let floor = Structure(float2(offset + size.x / 2, -random(0, size.y / 2)), size)
        let color = random(0.2, 0.4)
        floor.display.color = float4(color + random(0, 0.3), color + random(0, 0.3), color + random(0, 0.3), 1)
        return floor
    }
    
}

class BlockMaker: MakerAttachment<Structure> {
    
    override func make(_ floor: Structure) -> Structure? {
        let size = float2(random(0.2.m, 2.m), random(0.5.m, 1.m))
        let floorsize = floor.rect.bounds.x
        let struc = Structure(float2(floor.transform.location.x + random(-floorsize / 2, floorsize / 2), floor.transform.location.y - floor.rect.bounds.y / 2 + -random(-size.y / 2, size.y / 2)), size)
        struc.display.color = float4(random(0.2, 0.4), random(0.3, 0.5), random(0.1, 0.4), 1)
        return struc
    }
    
}

class GoalMaker: MakerAttachment<Structure> {
    let length: Float
    
    init(_ length: Float) {
        self.length = length
    }
    
    override func make(_ structure: Structure) -> Structure? {
        guard structure.transform.location.x > length - structure.rect.bounds.x else { return nil }
        let size = float2(0.5.m)
        let goal = Structure(structure.transform.location + float2(0, -structure.rect.bounds.y / 2 - size.y / 2), size)
        goal.display.color = float4(0, 1, 0, 1)
        goal.body.tag = "goal"
        return goal
    }
}

protocol SuperMaker {
    func make(_ offset: Float) -> [Actor]
}

class FloorSuperMaker: SuperMaker {
    var maker: Maker<Structure>
    var attachments: [MakerAttachment<Structure>]
    var characters: [MakerAttachment<Character>]
    
    init(_ length: Float) {
        maker = FloorMaker()
        attachments = []
        attachments.append(BlockMaker())
        //attachments.append(GoalMaker(length))
        characters = []
        //characters.append(SpawnerMaker())
    }
    
    func make(_ offset: Float) -> [Actor] {
        var ps: [Actor] = []
        let product = maker.make(offset)
        ps.append(product!)
        attachments.forEach{
            if let att = $0.make(product!) {
                ps.append(att)
            }
        }
        characters.forEach{
            if let att = $0.make(product!) {
                ps.append(att)
            }
        }
        return ps
    }
    
}

class Assembler {
    var makers: [SuperMaker]
    
    init() {
        makers = []
    }
    
    func make(_ offset: Float) -> [Actor] {
        var structs: [Actor] = []
        makers.forEach{ structs += $0.make(offset) }
        return structs
    }
}

class MasterMaker {
    var offset: Float
    var maker: Assembler
    var ready: () -> Bool
    var length: Float
    
    init(_ maker: Assembler, _ length: Float, _ ready: @escaping () -> Bool) {
        self.ready = ready
        self.length = length
        offset = 0
        self.maker = maker
    }
    
    func make() -> [Actor] {
        if ready() && offset < length {
            let structs = maker.make(offset)
            offset += 10.m
            return structs
        }
        return []
    }
}
