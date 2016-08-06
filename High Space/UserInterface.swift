//
//  UserInterface.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol DisplayLayer: Interface {
    func update()
    func display()
}

class GameState {
    static var levelgateway: LevelInfoGateway!
    static var level: LevelInfo!
    static var nextlevel: LevelInfo { return levelgateway.retrieveAfter(level.name) }
    static var difficulty: Difficulty! = Difficulty.Normal
    static var profile: UserProfile!
    
    static func updateProfile(level: Int, _ points: Int) {
        profile.updateLevel(level)
        profile.updatePoints(level, points)
        ProfileGateway().persist(profile)
    }
}

class Difficulty {
    let length: Float
    let enemyAmount: Float
    let clawspeed: Float
    let platforms: Int
    let simspeed: Float
    
    init(length: Float, enemies: Float, clawspeed: Float, simspeed: Float, platforms: Int){
        self.length = length
        self.enemyAmount = enemies
        self.clawspeed = clawspeed
        self.simspeed = simspeed
        self.platforms = platforms
    }
    
    static let Kid = Difficulty(length: 0.6, enemies: 0.5, clawspeed: 0.6, simspeed: 0.8, platforms: 0)
    static let Easy = Difficulty(length: 0.8, enemies: 0.5, clawspeed: 0.8, simspeed: 1.0, platforms: 0)
    static let Normal = Difficulty(length: 1, enemies: 1, clawspeed: 1, simspeed: 1.2, platforms: 1)
    static let Hard = Difficulty(length: 1.2, enemies: 1.5, clawspeed: 1.05, simspeed: 1.4, platforms: 2)
    static let Insane = Difficulty(length: 1.4, enemies: 1.5, clawspeed: 1.1, simspeed: 1.6, platforms: 4)
    
}

public class UserInterface {
    
    enum ScreenName {
        case Menu, Title
    }
    
    static var screen: Screen!
    static var controller = MainController()
    
    static var screens: [ScreenName: Screen] = [:]
    
    static func setScreen(screen: Screen) {
        self.screen = screen
    }
    
    static func switchScreen(name: ScreenName) {
        self.screen = screens[name]
    }
    
    static func update() {
        controller.getCommands().forEach(screen.use)
        screen.update()
    }
    
    static func display () {
        screen.display()
    }
    
}

public class Screen: Interface {
    
    //static let background = Image(texture: getTexture("Menu-Back"))
    
    var layers: [DisplayLayer] = []
    
    func update() {
        layers.forEach{$0.update()}
    }
    
    func display() {
        //Screen.background.display()
        layers.forEach{$0.display()}
    }
    
    func use(command: Command) {
        Trigger.process(command) { [unowned self] (command) in
            self.layers.reverse().forEach{$0.use(command)}
        }
    }
    
}

public class InterfaceLayer: DisplayLayer {
    
    var location = float2()
    var objects: [InterfaceElement] = []
    var active = true
    
    func setLocation(newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (amount: float2) {
        for obj in objects {
            obj.move(amount)
        }
        location += amount
    }
    
    func update() {
        
    }
    
    func display() {
        guard active else { return }
        objects.forEach{$0.display()}
    }
    
    func use(command: Command) {
        guard active else { return }
        objects.map{$0 as? Interface}.forEach{$0?.use(command)}
    }
    
}

public class InterfaceElement {
    
    static let atlas = Atlas("GUI", true)
    
    var location = float2()
    //var image: Image!
    
    init() {
        
    }
    
    init(_ location: float2, _ name: String) {
       createImage(location, name)
    }
    
    static func bounds (name: String) -> float2 {
        return InterfaceElement.atlas.textures[name]!.bounds
    }
    
    func createImage (location: float2, _ name: String) {
//        if let texture = InterfaceElement.atlas.textures[name] {
//            image = Image(atPosition: location.GLKVector(), inBounds: texture.bounds.GLKVector(), withTexture: texture.atlas.texture.texture, selectingCoordinates: texture.coordinates.asFloatData())
//        }
    }
    
    func setLocation (newLocation: float2) {
        move(newLocation - location)
    }
    
    func move (amount: float2) {
        //image.location = (float2(image.location) + amount).GLKVector()
        location += amount
    }
    
    func display() {
//        guard let img = image else { return }
//        img.display()
    }
    
}