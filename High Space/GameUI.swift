//
//  GameUI.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/16/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

extension DynamicText {
    
    var frame: float2 {
        return float2(Float(self.attrString.size().width), Float(self.attrString.size().height))
    }
    
    static func defaultStyle(_ string: String, _ color: float4, _ size: Float) -> DynamicText {
        let string = NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont(name: "FredokaOne-Regular", size: CGFloat(size))!, NSForegroundColorAttributeName: UIColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: CGFloat(color.w))])
        return DynamicText(attributedString: string)
    }
    
}

class StarshipScreen: Screen {
    
    let background: Display
    let score: TextElement
    
    var levels: [Level]
    
    override init() {
        background = Display(Rect(Camera.size / 2, Camera.size), GLTexture("galaxy"))
        background.transform.assign(Camera.transform)
        score = TextElement(float2(125, 60), DynamicText.defaultStyle(" ", float4(1), 32))
        levels = []
        for n in 0 ..< 5 {
            levels.append(Level(1 + n * 2))
        }
        
        super.init()
        
        let layer = InterfaceLayer()
        
        let count = 5
        
        let start = Camera.size.x / 2 - (Float(count - 1) * 1.m) / 2
        
        for n in 0 ..< count {
            let planet = PlanetView(float2(start + Float(n) * 1.m, Camera.size.y / 2), levels[n])
            planet.circle.color = float4(random(0.7, 1), random(0.7, 1), random(0.7, 1), 1)
            layer.objects.append(planet)
        }
        
        layers.append(layer)
    }
    
    override func display() {
        background.render()
        super.display()
        score.setText(DynamicText.defaultStyle("Pages: \(Score.pages)", float4(1), 48))
        score.display()
    }
    
}

class PlanetView: InterfaceElement, Interface {
    
    let circle: Display
    let shape: Circle
    let transform: Transform
    let level: Level
    
    init(_ location: float2, _ level: Level) {
        self.level = level
        transform = Transform(location)
        transform.assign(Camera.transform)
        shape = Circle(transform, 0.4.m)
        circle = Display(shape, GLTexture("planet"))
        super.init(location)
    }
    
    func use(_ command: Command) {
        if let point = command.vector {
            if shape.getBounds().contains(point) {
                UserInterface.setScreen(PrincipalScreen(level))
            }
        }
    }
    
    override func display() {
        circle.render()
    }
    
}

class PrincipalScreen: Screen {
    let corruption: TextElement
    let depth: TextElement
    let score: TextElement
    let game: Game
    
    init(_ level: Level) {
        corruption = TextElement(float2(Camera.size.x - 300, 125), DynamicText.defaultStyle(" ", float4(1), 32))
        self.depth = TextElement(float2(325, 100), DynamicText.defaultStyle(" ", float4(1), 32))
        score = TextElement(float2(325, 150), DynamicText.defaultStyle(" ", float4(1), 32))
        game = Game(level)
        
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        layers.append(game)
        layers.append(StatusLayer(game))
        //layers.append(InventoryView())
    }
    
    deinit {
        let _ = UserInterface.controller.stack.pop()
    }
    
    override func use(_ command: Command) {
        layers.reversed().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
        
        let dreath = game.level.dreathmap.totalDreath()
        let dis = dreath / 100
        corruption.setText(DynamicText.defaultStyle("Dreath: \(String(format: "%.1f", dis))", float4(1), 48))
        corruption.display()
        let dp = game.level.depth == 0 ? "infinity" : "\(game.level.depth)"
        depth.setText(DynamicText.defaultStyle("Depth: \(game.level.rooms.count - 1) of \(dp)", float4(1), 48))
        depth.display()
        score.setText(DynamicText.defaultStyle("Pages: \(Score.pages)", float4(1), 48))
        score.display()
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
        
        layer.objects.append(TextElement(Camera.size / 2, DynamicText.defaultStyle(text, float4(1), 128)))
        layer.objects.append(TextButton(DynamicText.defaultStyle("Restart", float4(1), 86), Camera.size / 2 + float2(0, 400), {
           UserInterface.switchScreen(0)
        }))
        
        layers.append(layer)
    }
    
}

class PauseLayer: InterfaceLayer {
    
    override init() {
        super.init()
        let base = Camera.size / 2 - float2(0, 200)
        objects.append(Button("Resume", base))
        objects.append(Button("Restart", base + float2(0, 200)))
//        objects.append(Button("Menu", base + float2(0, 400)) {
//            UserInterface.switchScreen(.menu)
//        })
    }
    
}

class StatusLayer: InterfaceLayer {
    let game: Game
    let status: Player
    let element: ShieldElement
    let weapon: StatusElement
    let laser: StatusElement
    let ship: TextButton
    
    init(_ game: Game) {
        self.game = game
        self.status = game.player
        element = ShieldElement(status.shield)
        weapon = StatusElement(status.weapon, float2())
        laser = StatusElement(status.laser, float2(0, 30))
        ship = TextButton(DynamicText.defaultStyle("ship", float4(0, 0, 0, 1), 64.0), float2(Camera.size.x / 2, 50)) {
            UserInterface.switchScreen(0)
        }
    }
    
    override func use(_ command: Command) {
        if FixedRect.intersects(game.ship.rect.getBounds(), game.player.body.shape.getBounds()) && game.level.index == 0 {
            ship.use(command)
        }
    }
    
    override func display() {
        element.render()
        weapon.render()
        laser.render()
        if FixedRect.intersects(game.ship.rect.getBounds(), game.player.body.shape.getBounds()) && game.level.index == 0 {
            ship.display()
        }
    }
}

class InventoryView: InterfaceLayer {
    let number: TextElement
    
    override init() {
        number = TextElement(float2(), DynamicText.defaultStyle(" ", float4(1), 16))
    }
    
    override func display() {
        let width = 6
        let height = 3
        let start = float2(Camera.size.x / 2 - Float(width - 1) * 0.5.m / 2, Camera.size.y / 2 - Float(height - 1) * 0.5.m / 2)
        var x = 0, y = 0
        for stack in Score.inventory.items {
            let item = stack.items.first!
            let loc = start + float2(Float(x) * 0.5.m, Float(y) * 0.5.m)
            item.transform.location = loc + Camera.transform.location
            if x >= width - 1 {
                y += 1
                x = 0
            }else{
                x += 1
            }
            item.render()
            number.setLocation(loc + float2(30, 30))
            number.setText(DynamicText.defaultStyle("\(stack.items.count)", float4(1), 48))
            number.display()
        }
    }
    
}

class ShieldElement {
    let frame: Display
    let level: Display
    let rect: Rect
    let transform: Transform
    let status: Shield
    let size: float2
    
    init(_ status: Shield) {
        self.status = status
        size = float2(650, 22.5)
        frame = Display(Rect(float2(), size), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 0.2)
        rect = Rect(float2(), float2(size.x - 7, size.y - 3))
        level = Display(rect, GLTexture("white"))
        level.color = float4(0.4, 1, 0.5, 1)
        transform = frame.scheme.hull.transform
        rect.transform.assign(transform)
        transform.assign(Camera.transform)
        transform.location = float2(size.x / 2 + 30, 30)
    }
    
    func render() {
        let rectsize = float2(size.x - 7, size.y - 3)
        let adjust = rectsize.x * status.points.percent
        rect.setBounds(float2(adjust, rectsize.y))
        rect.transform.location.x = -rectsize.x / 2 + adjust / 2
        level.visual.refresh()
        frame.render()
        level.render()
    }
}

class StatusElement {
    let frame: Display
    let level: Display
    let rect: Rect
    let transform: Transform
    let status: Weapon
    let size: float2
    
    init(_ status: Weapon, _ offset: float2) {
        self.status = status
        size = float2(550, 15)
        frame = Display(Rect(float2(), size), GLTexture("white"))
        frame.color = float4(0.3, 0.3, 0.3, 0.2)
        rect = Rect(float2(), float2(size.x - 7, size.y - 3))
        level = Display(rect, GLTexture("white"))
        level.color = float4(1, 0.2, 0.1, 1)
        transform = frame.scheme.hull.transform
        rect.transform.assign(transform)
        transform.assign(Camera.transform)
        transform.location = float2(-size.x / 2 - 30 + Camera.size.x, 30) + offset
    }
    
    func render() {
        let rectsize = float2(size.x - 7, size.y - 3)
        let adjust = rectsize.x * status.stats.power.percent
        rect.setBounds(float2(adjust, rectsize.y))
        rect.transform.location.x = rectsize.x / 2 - adjust / 2
        level.visual.refresh()
        frame.render()
        level.render()
    }
}













