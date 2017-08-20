//
//  core.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation

let defaultFont = "Lora-Regular"
let defaultStyle = FontStyle(defaultFont, float4(1), 72)
let sound_volume: Float = 0.1

@objc class MainGame: NSObject {
    
    let interface: GameInterface
    
    override init() {
        
//        let f = UIFont.familyNames
//        for m in f {
//            for n in UIFont.fontNames(forFamilyName: m) {
//                print(n.description)
//            }
//        }
//        
        
        GameScreen.create()
        interface = GameRenderTest()
        super.init()
    }
    
    func update() {
        interface.update()
    }
    
    func display() {
        interface.render()
    }
    
}

protocol GameInterface {
    func update()
    func render()
}

class GameRenderTest: GameInterface {
    
    let method: SortedRendererMethod
    
    init() {
        Camera.current = Camera()
        
        method = SortedRendererMethod()
        
        method.create(GraphicsInfo(Rect(float2(3.m, -3.m), float2(2.m, 1.m)), ClassicMaterial(GLTexture())))
        method.create(GraphicsInfo(Rect(float2(4.m, -5.m), float2(2.m, 2.m)), ClassicMaterial(GLTexture())))
        
        print(method.rootNode.describe())
    }
    
    func update() {
        method.update()
    }
    
    func render() {
        method.render()
    }
    
}

class GameTester: GameInterface {
    
    init() {
        let sorter = SortingTester()
        sorter.update()
    }
    
    func update() {
        
    }
    
    func render() {
        
    }
    
}

var upgrader: Upgrader!

class GameBase: GameInterface {
    
    init() {
        upgrader = Upgrader()
        
        Camera.current = Camera()
        
        UserInterface.create()
        GameData.create()
        
        for u in upgrader.upgrades {
            u.range.amount = Float(GameData.info.upgrades[u.name]!)
        }
        
        GameData.info.level = 0
       // GameData.info.points = 15
        GameData.info.wave = 0
            

//        upgrader.firepower.range.amount = 5
//        upgrader.shieldpower.range.amount = 5
//        upgrader.barrier.range.amount = 5
//
        let main = ScreenSpace()
        main.push(Splash())
//        main.push(PrincipalScreen())
        //main.push(StoreScreen())
//        main.push(StoryScreen(StoryOutro()))
        UserInterface.set(space: main)
    }
    
    func update() {
        UserInterface.update()
    }
    
    func render() {
        UserInterface.display()
    }
    
}

@objc class Time: NSObject {
    static var delta: Float = 0
    static var scale: Float = 1
    static var normal: Float = 0
    
    static func set(_ time: Float) {
        self.delta = time * scale
        self.normal = time
    }
}
