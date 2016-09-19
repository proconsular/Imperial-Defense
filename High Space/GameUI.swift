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

class PrincipalScreen: Screen {
    let corruption: TextElement
    let depth: TextElement
    let game: Game
    
    override init() {
        corruption = TextElement(float2(300, 100), DynamicText.defaultStyle(" ", float4(1), 32))
        depth = TextElement(float2(325, 100), DynamicText.defaultStyle(" ", float4(1), 32))
        game = Game()
        
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        layers.append(game)
        layers.append(StatusLayer(game.player))
    }
    
    deinit {
        UserInterface.controller.stack.pop()
    }
    
    override func use(_ command: Command) {
        layers.reversed().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
        
//        let dreath = game.dreathmap.totalDreath()
//        let dis = dreath / 100
        //corruption.setText(DynamicText.defaultStyle("Dreath: \(String(format: "%.1f", dis))", float4(1), 64))
//        corruption.setText(DynamicText.defaultStyle("Actors: \(game.controller.grid.actors.count)", float4(1), 64))
        //corruption.display()
        let dp = game.level.depth == 0 ? "infinity" : "\(game.level.depth)"
        depth.setText(DynamicText.defaultStyle("Depth: \(game.level.rooms.count - 1) of \(dp)", float4(1), 48))
        depth.display()
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
           UserInterface.setScreen(PrincipalScreen())
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
        objects.append(Button("Menu", base + float2(0, 400)) {
            UserInterface.switchScreen(.menu)
        })
    }
    
}

class StatusLayer: InterfaceLayer {
    let status: Player
    let element: ShieldElement
    let weapon: StatusElement
    let laser: StatusElement
    let restart: TextButton
    
    init(_ status: Player) {
        self.status = status
        element = ShieldElement(status.shield)
        weapon = StatusElement(status.weapon, float2())
        laser = StatusElement(status.laser, float2(0, 30))
        restart = TextButton(DynamicText.defaultStyle("restart", float4(0, 0, 0, 1), 64.0), float2(Camera.size.x / 2, 50)) {
            UserInterface.setScreen(PrincipalScreen())
        }
    }
    
    override func use(_ command: Command) {
        restart.use(command)
    }
    
    override func display() {
        element.render()
        weapon.render()
        laser.render()
        restart.display()
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













