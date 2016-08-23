//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    let background: Display
    let controller: GameController
    var maker: MasterMaker!
    
    let dreathmap: DreathMap
    
    let player: Player
    
    init() {
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture("galaxy"))
        background.scheme.hull.transform.assign(Camera.transform)
        
        let map = GameMap()
        
        controller = GameController(map)
        
        dreathmap = DreathMap(controller)
        
        player = Player(float2(Camera.size.x / 2, -2.m), Weapon(controller))
        player.callback = {
            if $0 == "goal" {
                self.victory()
            }
        }
        
        map.player = player
        
        controller.append(Structure(float2(0, -Camera.size.y / 2), float2(30, Camera.size.y)))
        
        
        controller.append(player)
        
        Camera.follow = player.transform
        
        let length = 100.m
        
        let assm = Assembler()
        let floormaker = FloorSuperMaker(length)
        //floormaker.characters.append(BlobMaker(map))
        assm.makers.append(floormaker)
        
        maker = MasterMaker(assm, length) {
            self.player.transform.location.x >= self.maker.offset - 10.m
        }
    }
    
    func victory() {
        UserInterface.setScreen(EndScreen(ending: .Victory))
    }
    
    func use(command: Command) {
        player.use(command)
    }
    
    func update() {
        dreathmap.update()
        if player.shield.points.amount <= 0 {
            UserInterface.setScreen(EndScreen(ending: .Lose))
        }
        maker.make().forEach(controller.append)
        controller.update()
        Camera.update()
    }
    
    func display() {
        //background.render()
        controller.render()
    }
}

class GameController {
    let rendermaster: RenderMaster
    let physics: Physics
    var actors: [Actor]
    var map: GameMap
    var new: [Actor]
    
    init(_ map: GameMap) {
        self.map = map
        rendermaster = RenderMaster()
        rendermaster.layers.append(RenderLayer())
        physics = Physics()
        actors = []
        new = []
    }
    
    func append(actor: Actor) {
        new.append(actor)
    }
    
    private func insert(actor: Actor) {
        actors.append(actor)
        physics.bodies.append(actor.body)
        rendermaster.layers.first?.displays.append(actor.display)
    }
    
    func update() {
        actors.forEach{ $0.update() }
        actors.forEach{ $0.onObject = false }
        
        physics.update()
        
        for n in new {
            insert(n)
        }
        new.removeAll()
        delete()
        
    }
    
    private func delete() {
        let copy = actors
        for n in 0 ..< copy.count {
            if Camera.distance(copy[n].transform.location) > 100.m {
                remove(n)
            }
        }
        while let index = findDead() {
            remove(index)
        }
        actors.map{ $0 as? Bullet }.enumerate().forEach {
            if let bullet = $1 {
                if !bullet.active { remove($0) }
            }
        }
    }
    
    private func findDead() -> Int? {
        let clone = actors
        for n in 0 ..< clone.count {
            if let char = clone[n] as? Character {
                if char.status.hitpoints.amount <= 0 {
                    return n
                }
            }
        }
        return nil
    }
    
    func remove(index: Int) {
        guard index < physics.bodies.count else { return }
        physics.bodies.removeAtIndex(index)
        rendermaster.layers.first?.displays.removeAtIndex(index)
        actors.removeAtIndex(index)
    }
    
    func render() {
        rendermaster.render()
    }
}

class Physics {
    var bodies: [Body]
    
    init() {
        Simulation.create()
        bodies = []
    }
    
    func update() {
        Simulation.simulate(&bodies)
    }
}















