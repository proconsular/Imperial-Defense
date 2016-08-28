//
//  Region.swift
//  Comm
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Game: DisplayLayer {
    
    static let levelsize = 30.m
    
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
        
        dreathmap = DreathMap(controller.grid, map)
        
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
        
        let assm = Assembler()
        let floormaker = FloorSuperMaker(Game.levelsize)
        floormaker.characters.append(SpawnerMaker())
        //floormaker.characters.append(BlobMaker(map))
        assm.makers.append(floormaker)
        
        maker = MasterMaker(assm, Game.levelsize) {
            self.maker.offset < Game.levelsize
        }
        
        for _ in 0 ..< 10 {
            maker.make().forEach(controller.append)
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
//        maker.make().forEach(controller.append)
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
    let renderlayer: RenderLayer
    let physics: Simulation
    let grid: Grid
    var map: GameMap
    
    init(_ map: GameMap) {
        self.map = map
        rendermaster = RenderMaster()
        renderlayer = RenderLayer()
        rendermaster.layers.append(renderlayer)
        grid = Grid(10.m, float2(Game.levelsize, 10.m))
        physics = Simulation(grid)
    }
    
    func append(actor: Actor) {
        grid.append(actor)
    }
    
    func update() {
        grid.update()
        physics.simulate()
    }
    
    func render() {
        let cells = grid.cells.filter{
            let rect = FixedRect(grid.getCellLocation($0), float2(grid.size + 2.m))
            return Camera.contains(rect)
        }
        cells.forEach {
            $0.elements.map{ $0.element }.forEach{
                //if Camera.distance($0.transform.location) <= Camera.size.length + 5.m {
                    $0.display.render()
                //}
            }
        }
    }
}















