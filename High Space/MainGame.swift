//
//  core.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 8/21/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

import Foundation

let defaultStyle = FontStyle("Metropolis-ExtraLight", float4(1), 72)
let defaultFont = "Metropolis-ExtraLight"

@objc class MainGame: NSObject {
    
    let interface: GameInterface
    
    override init() {
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

class GameExperiment: GameInterface {
    
    let texture: Texture
    let display: Display
    var data: [UInt32]
    let count = 512
    
    init() {
        data = Array<UInt32>(repeating: 0, count: count * count)
        texture = Texture(float2(Float(count)))
        texture.create(data)
        display = Display(Rect(Camera.size / 2, Camera.size), texture)
    }
    
    func update() {
        
    }
    
    func render() {
        data = data.rotate(-1)
        let random = Int(arc4random() % UInt32(data.count))
        
        data[random] = Texture.computeColor(float4(1, 0.5, 1, 1))
        texture.create(data)
        
        display.render()
    }
    
}

class GameBase: GameInterface {
    
    init() {
        UserInterface.create()
        GameData.create()
        
        let main = ScreenSpace()
        main.push(PrincipalScreen())
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
