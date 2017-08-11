//
//  UserInterface.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol DisplayLayer: Interface {
    func update()
    func display()
}

class UserInterface {
    
    static var controller = MainController()
    
    static var spaces: [ScreenSpace] = []
    static var index = 0
    
    static var transition: FadeTransition!
    
    static var space: ScreenSpace {
        return spaces[index]
    }
    
    static func create() {
        transition = FadeTransition(2)
        transition.transition(-1)
        //controller.push(PointController(0))
    }
    
    static func update() {
        let commands = controller.getCommands()
        for command in commands {
            space.use(command)
        }
        space.update()
        Graphics.update()
    }
    
    static func display() {
        space.display()
        transition.render()
    }
    
    static func set(index: Int) {
        self.index = index
    }
    
    static func set(space: ScreenSpace) {
        spaces.append(space)
        index = spaces.count - 1
    }
    
    static func push(_ screen: Screen) {
        space.push(screen)
    }
    
    static func fade(_ callback: @escaping () -> ()) {
        UserInterface.transition.transition(1) {
            callback()
            UserInterface.transition.transition(-1)
        }
    }
    
}

class FadeTransition {
    
    let fade: Fade
    var active: Bool
    var callback: () -> ()
    
    init(_ rate: Float) {
        fade = Fade(rate)
        callback = {_ in}
        active = false
    }
    
    func transition(_ direction: Float, _ callback: @escaping () -> () = {_ in}) {
        fade.direction = direction
        fade.opacity = direction == 1 ? 0 : 1
        self.callback = callback
        active = true
    }
    
    func render() {
        if active {
            if fade.opacity == (fade.direction == 1 ? 1 : 0) {
                callback()
                active = false
            }
        }
        fade.render()
    }
    
}

class Fade {
    
    var background: Display!
    var opacity: Float
    var direction: Float
    var rate: Float
    
    init(_ rate: Float) {
        self.rate = rate
        opacity = 0
        direction = 0
        background = Display(Rect(GameScreen.size / 2 + float2(0, -GameScreen.size.y), GameScreen.size) , GLTexture())
        background.color = float4(0) * float4(0, 0, 0, 1)
    }
    
    func render() {
        opacity = clamp(opacity + direction * rate * Time.delta, min: 0, max: 1)
        background.color = float4(0, 0, 0, opacity)
        background.refresh()
        background.render()
    }
    
}
















