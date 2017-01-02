//
//  GameUI.swift
//  Imperial Defence
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PrincipalScreen: Screen {
    let game: Game
    
    override init() {
        game = Game()
        
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        layers.append(game)
        layers.append(StatusLayer(game))
    }
    
    deinit {
        UserInterface.controller.reduce()
    }
    
    override func use(_ command: Command) {
        layers.reversed().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
    }
    
}

class TitleScreen: Screen {
    let background: Display
    
    override init() {
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2), Camera.size), GLTexture("stonefloor"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.7, 0.7, 0.7, 1)
        background.scheme.camera = false
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let spread: Float = 200
        let size: Float = 72
        
        let style = FontStyle(defaultFont, float4(1), size)
        
        layer.objects.append(TextButton(Text("Story", style), float2(Camera.size.x / 2, Camera.size.y / 2 - spread)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Forever", style), float2(Camera.size.x / 2, Camera.size.y / 2)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layer.objects.append(TextButton(Text("Reset", style), float2(Camera.size.x / 2, Camera.size.y / 2 + spread)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
    }
    
}

class StoreScreen: Screen {
    let background: Display
    let points: Text
    
    override init() {
        background = Display(Rect(float2(Camera.size.x / 2, -Camera.size.y / 2), Camera.size), GLTexture("stonefloor"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.7, 0.7, 0.7, 1)
        
        points = Text(" ", defaultStyle)
        points.location = float2(Camera.size.x / 2, 60)
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let spacing = float2(600, 400)
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - spacing.x, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[0]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[1]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + spacing.x, Camera.size.y / 2 - spacing.y / 2), Data.info.upgrades[2]))
        
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 - spacing.x, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[3]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[4]))
        layer.objects.append(UpgradeView(float2(Camera.size.x / 2 + spacing.x, Camera.size.y / 2 + spacing.y / 2), Data.info.upgrades[5]))
        
        layer.objects.append(TextButton(Text("Next", defaultStyle), float2(Camera.size.x / 2, Camera.size.y - 50)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layers.append(layer)
        
    }
    
    override func display() {
        background.render()
        points.setString("\(Data.info.points)")
        points.render()
        super.display()
    }
}

class StoryScreen: Screen {
    let background: Display
    var text: Text
    
    override init() {
        background = Display(Rect(float2(Camera.size.x / 2, Camera.size.y / 2), Camera.size), GLTexture("white"))
        background.scheme.layout.coordinates = [float2(0, 0), float2(2, 0) * 2, float2(2, 3) * 2, float2(0, 3) * 2]
        background.color = float4(0.01, 0.01, 0.01, 1)
        
        text = Text("This is where the story will go.\nHopefully there are line breaks. We'll see.", FontStyle(defaultFont, float4(1), 52.0), float2(300, 100))
        text.location = float2(Camera.size.x / 2, 400)
        super.init()
    }
    
    override func display() {
        background.render()
        super.display()
        text.render()
    }
    
}

class UpgradeView: InterfaceElement, Interface {
    
    let upgrade: Upgrade
    
    let background: Display
    var icon: Display?
    
    var text: Text!
    var button: InteractiveElement!
    
    init(_ location: float2, _ upgrade: Upgrade) {
        self.upgrade = upgrade
        
        background = Display(Circle(Transform(location + float2(0, -Camera.size.y)), 135), GLTexture("white"))
        background.color = float4(0.2, 0.4, 0.3, 1)
        
        icon = Display(Rect(background.transform, float2(150)), GLTexture(upgrade.name.lowercased()))
        
        super.init(location)
        
        button = InteractiveElement(location, float2(300)) {
            self.buy()
        }
        
        text = Text("upgrade: amount", FontStyle(defaultFont, float4(1), 48))
        text.location = location + float2(0, 175)
    }
    
    func buy() {
        let cost = self.upgrade.computeCost()
        if Data.info.points >= cost {
            Data.info.points -= cost
            self.upgrade.upgrade()
        }
        Data.persist()
    }
    
    func use(_ command: Command) {
        button.use(command)
    }
    
    override func display() {
        super.display()
        background.render()
        icon?.render()
        text.setString("\(upgrade.name): (\(upgrade.computeCost()))")
        text.render()
    }
    
}

class EndScreen: Screen {
    
    enum Ending {
        case victory, lose
    }
    
    init(ending: Ending) {
        super.init()
        
        let layer = InterfaceLayer()
        
        var text = ""
        
        if case .victory = ending {
            text = "Victory!"
        }else{
            text = "You died."
        }
        
//        layer.objects.append(TextElement(Camera.size / 2, Text(text, FontStyle(defaultFont, float4(1), 128))))
        layer.objects.append(TextButton(Text("Restart", FontStyle(defaultFont, float4(1), 86)), Camera.size / 2 + float2(0, 400), {
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
        }))
        
        layers.append(layer)
    }
    
}

class WinScreen: Screen {
    
    override init() {
        super.init()
        
        let layer = InterfaceLayer()
        
//        layer.objects.append(TextElement(Camera.size / 2,  Text("You Won!", FontStyle(defaultFont, float4(1), 128))))
        layer.objects.append(TextButton(Text("Next", FontStyle(defaultFont, float4(1), 86)), Camera.size / 2 + float2(0, 400), {
            Data.info.level += 1
            Data.persist()
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
        }))
        
        layers.append(layer)
    }
    
}

class PauseScreen: Screen {
    
    override init() {
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextButton(Text("Resume", defaultStyle), Camera.size / 2 + float2(0, -75)) {
            UserInterface.space.pop()
        })
        
        layer.objects.append(TextButton(Text("Title", defaultStyle), Camera.size / 2 + float2(0, 75)) {
            UserInterface.space.wipe()
            UserInterface.space.push(TitleScreen())
        })
        
        layers.append(layer)
    }
    
}

class StatusLayer: InterfaceLayer {
    let wave: Text
    let points: Text
    
    let shield: DisplayElement
    let laser: DisplayElement
    
    init(_ game: Game) {
        shield = DisplayElement(float2(135, 25), float2(400, 22.5), 1, game.player.shield)
        laser = DisplayElement(float2(Camera.size.x - 30, 30), float2(550, 15), -1, game.player.laser)
        
        wave = Text(" ", FontStyle(defaultFont, float4(1), 48.0))
        wave.location = float2(300, 100)
        points = Text(" ", FontStyle(defaultFont, float4(1), 72.0))
        points.location = float2(Camera.size.x / 2, 60)
        
        super.init()
        
        objects.append(TextButton(Text("II", FontStyle(defaultFont, float4(1), 72.0)), float2(50), {
            UserInterface.space.push(PauseScreen())
        }))
    }
    
    override func display() {
        super.display()
        
        shield.render()
        
        wave.setString("level: \(Data.info.level)")
        wave.render()
        
        points.setString("\(Data.info.points)")
        points.render()
        
        laser.render()
    }
}

protocol StatusItem {
    var percent: Float { get }
}

class DisplayElement {
    
    let status: StatusItem
    
    let transform: Transform
    let frame, level: Display
    let rect: Rect
    let size: float2
    let alignment: Int
    
    init(_ location: float2, _ size: float2, _ alignment: Int, _ status: StatusItem) {
        self.status = status
        self.size = size
        self.alignment = alignment
        
        frame = Display(Rect(float2(), size), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 0.2)
        
        rect = Rect(float2(), float2(size.x, size.y))
        level = Display(rect, GLTexture("white"))
        level.color = float4(0.4, 1, 0.5, 1)
        
        transform = frame.scheme.hull.transform
        transform.assign(Camera.transform)
        transform.location = location + float2(size.x / 2 * Float(alignment), 0)
        
        rect.transform.assign(transform)
    }
    
    func render() {
        let adjust = size.x * status.percent
        rect.setBounds(float2(adjust, size.y))
        rect.transform.location.x = Float(alignment) * (-size.x / 2 + adjust / 2)
        
        level.visual.refresh()
        frame.render()
        level.render()
    }
    
}









