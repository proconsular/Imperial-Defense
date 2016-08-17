//
//  Creator.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/11/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Maker<Product> {
    func make(offset: Float) -> Product! { return nil }
}


class MakerAttachment<Product> {
    func make(structure: Structure) -> Product! { return nil }
}

class FloorMaker: Maker<Structure> {
    
    override func make(offset: Float) -> Structure! {
        let size = float2(10.m, random(1.m, 2.m))
        let floor = Structure(float2(offset + size.x / 2, -random(0, size.y / 2)), size)
        return floor
    }
    
}

class BlockMaker: MakerAttachment<Structure> {
    
    override func make(floor: Structure) -> Structure! {
        let size = float2(random(0.2.m, 2.m), random(0.5.m, 1.m))
        let floorsize = floor.rect.bounds.x
        return Structure(float2(floor.transform.location.x + random(-floorsize / 2, floorsize / 2), floor.transform.location.y - floor.rect.bounds.y / 2 + -random(-size.y / 2, size.y / 2)), size)
    }
    
}

class BlobMaker: MakerAttachment<Character> {
    let map: GameMap
    
    init(_ map: GameMap) {
        self.map = map
    }
    
    override func make(structure: Structure) -> Character! {
        return Character(float2(structure.transform.location.x, structure.transform.location.y - 5.m), float2(0.15.m), Director(map))
    }
    
}

protocol SuperMaker {
    func make(offset: Float) -> [Actor]
}

class FloorSuperMaker: SuperMaker {
    var maker: Maker<Structure>
    var attachments: [MakerAttachment<Structure>]
    var characters: [MakerAttachment<Character>]
    
    init() {
        maker = FloorMaker()
        attachments = []
        attachments.append(BlockMaker())
        characters = []
    }
    
    func make(offset: Float) -> [Actor] {
        var ps: [Actor] = []
        let product = maker.make(offset)
        ps.append(product)
        attachments.forEach{ ps.append($0.make(product)) }
        characters.forEach{ ps.append($0.make(product)) }
        return ps
    }
    
}

class Assembler {
    var makers: [SuperMaker]
    
    init() {
        makers = []
    }
    
    func make(offset: Float) -> [Actor] {
        var structs: [Actor] = []
        makers.forEach{ structs += $0.make(offset) }
        return structs
    }
}

class MasterMaker {
    var offset: Float
    var maker: Assembler
    var ready: () -> Bool
    
    init(_ maker: Assembler, _ ready: () -> Bool) {
        self.ready = ready
        offset = 0
        self.maker = maker
    }
    
    func make() -> [Actor] {
        if ready() {
            let structs = maker.make(offset)
            offset += 10.m
            return structs
        }
        return []
    }
}