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
    
    static func defaultStyle(string: String, _ color: float4, _ size: Float) -> DynamicText {
        let string = NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont(name: "FredokaOne-Regular", size: CGFloat(size))!, NSForegroundColorAttributeName: UIColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: CGFloat(color.w))])
        return DynamicText(attributedString: string)
    }
    
}

class PrincipalScreen: Screen {
    
    override init() {
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        let game = Game()
        
        layers.append(game)
        layers.append(StatusLayer(game.player.status))
    }
    
    deinit {
        UserInterface.controller.stack.pop()
    }
    
    override func use(command: Command) {
        layers.reverse().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
    }
    
}

class EndScreen: Screen {
    
    enum Ending {
        case Victory, Lose
    }
    
    init(ending: Ending) {
        super.init()
        
        let layer = InterfaceLayer()
        
        var text = ""
        
        if case .Victory = ending {
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
            UserInterface.switchScreen(.Menu)
        })
    }
    
}

class StatusLayer: InterfaceLayer {
    let status: Status
    let element: StatusElement
    
    init(_ status: Status) {
        self.status = status
        element = StatusElement(status)
    }
    
    override func display() {
        element.render()
    }
    
}

class StatusElement {
    let frame: Display
    let level: Display
    let rect: Rect
    let transform: Transform
    let status: Status
    let size: float2
    
    init(_ status: Status) {
        self.status = status
        size = float2(650, 20)
        frame = Display(Rect(float2(), size), GLTexture("white"))
        frame.scheme.info.color = float4(0.2, 0.2, 0.2, 0.5)
        rect = Rect(float2(), float2(size.x - 10, size.y - 5))
        level = Display(rect, GLTexture("white"))
        transform = frame.scheme.hull.transform
        rect.transform.assign(transform)
        transform.assign(Camera.transform)
        transform.location = float2(size.x / 2 + 30, 30)
    }
    
    func render() {
        let rectsize = float2(size.x - 10, size.y - 5)
        let adjust = rectsize.x * status.hitpoints.percent
        rect.setBounds(float2(adjust, rectsize.y))
        rect.transform.location.x = -rectsize.x / 2 + adjust / 2
        level.visual.refresh()
        frame.render()
        level.render()
    }
}













