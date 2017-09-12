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
let sound_volume: Float = 0.05

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
        interface = GameBase()
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
    
    let renderer: BaseRenderer
    let rect: Rect
    let rect2: Rect
    
    let graphic: GraphicsInfo
    
    init() {
        Camera.current = Camera()
        
        method = SortedRendererMethod()
        
        rect2 = Rect(float2(3.m, -3.m), float2(2.m, 1.m))
        
        method.create(GraphicsInfo(rect2, ClassicMaterial(GLTexture())))
        method.create(GraphicsInfo(Rect(float2(4.m, -5.m), float2(2.m, 2.m)), ClassicMaterial(GLTexture())))
        
        print(method.rootNode.describe())
        
        let gr = GraphicsInfo(Rect(float2(10.m, -5.m), float2(4.m, 2.m)), ClassicMaterial(GLTexture("stonefloor")))
        
        rect = Rect(float2(15.m, -5.m), float2(4.m, 2.m))
        
        graphic = GraphicsInfo(rect, ClassicMaterial(GLTexture("stonefloor")))
        
        renderer = BaseRenderer()
        
        renderer.append(gr)
        renderer.append(graphic)
        
        renderer.compile()
    }
    
    func update() {
        rect2.transform.location.x += 0.5.m * Time.delta
        rect2.transform.orientation += 0.4 * Time.delta
        
        method.update()
        
        rect.transform.location.x += 0.5.m * Time.delta
        rect.transform.orientation += 0.1 * Time.delta
        
        if rect.transform.location.x >= 20.m {
            graphic.active = false
        }
    }
    
    func render() {
        method.render()
        
        renderer.update()
        
        renderer.bind()
        renderer.render()
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
//        
//        GameData.info.level = 0
//       // GameData.info.points = 15
        
//        let wave = 49
//        
//        GameData.info.wave = wave - 1
//
        
//        upgrader.firepower.range.amount = 5
//        upgrader.shieldpower.range.amount = 5
//        upgrader.barrier.range.amount = 5
////
        let main = ScreenSpace()
//        main.push(Splash())
        main.push(PrincipalScreen())
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
