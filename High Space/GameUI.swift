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
        let string = NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont(name: "Metropolis-ExtraLight", size: CGFloat(size))!, NSForegroundColorAttributeName: UIColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: CGFloat(color.w))])
        return DynamicText(attributedString: string)
    }
    
}

class PrincipalScreen: Screen {
    let game: Game
    
    override init() {
        game = Game()
        
        super.init()
        
        UserInterface.controller.stack.push(GameControllerLayer())
        
        layers.append(game)
        layers.append(StatusLayer(game))
        //layers.append(InventoryView())
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

class StoreScreen: Screen {
    var upgrades: [TextButton]
    var points: TextElement
    
    override init() {
        upgrades = []
        
        upgrades.append(TextButton(DynamicText.defaultStyle("sniper: 0", float4(1), 64), float2(Camera.size.x / 2, Camera.size.y / 2)) {
            if Score.points >= 50 {
                Score.points -= 50
                Score.upgrade.upgrade()
            }
        })
        
        points = TextElement(float2(Camera.size.x / 2, 60), DynamicText.defaultStyle(" ", float4(1), 72.0))
        
        super.init()
        
        let layer = InterfaceLayer()
        
        upgrades.forEach{ layer.objects.append($0) }
        
        layer.objects.append(TextButton(DynamicText.defaultStyle("Next", float4(1), 64), float2(Camera.size.x / 2, Camera.size.y - 50)) {
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        })
        
        layers.append(layer)
        
    }
    
    override func display() {
        let text =  DynamicText.defaultStyle("sniper: \(Score.upgrade.range.amount)", float4(1), 64)
        text.location = upgrades[0].location
        upgrades[0].text = text
        points.setText(DynamicText.defaultStyle("\(Score.points)", float4(1), 72.0))
        points.display()
        super.display()
    }
    
}

class InventoryScreen: Screen {
    
    override init() {
        super.init()
        layers.append(InventoryView())
        
        let i = InterfaceLayer()
        i.objects.append(TextButton(DynamicText.defaultStyle("game", float4(1), 64), float2(Camera.size.x / 2, 50)) {
            UserInterface.space.pop()
        })
        layers.append(i)
    }
    
}

class ForgeScreen: Screen {
    let forgeview: ForgeView
    let inventoryview: InventoryView
    
    init(_ forge: Forge) {
        forgeview = ForgeView(forge)
        inventoryview = InventoryView()
        super.init()
        layers.append(forgeview)
        inventoryview.location = float2(0, 300)
        layers.append(inventoryview)
    }
    
    override func update() {
        super.update()
        
        if let fs = forgeview.selection, let isl = inventoryview.selection {
            if forgeview.isBlank(index: fs) {
                if !inventoryview.isBlank(index: isl) {
                    forgeview.append(index: fs, item: inventoryview.remove(index: isl) as! Gem)
                    forgeview.selection = nil
                    inventoryview.selection = nil
                }
            }else if inventoryview.isBlank(index: isl) {
                if !forgeview.isBlank(index: fs) {
                    inventoryview.append(index: isl, forgeview.remove(index: fs))
                    forgeview.selection = nil
                    inventoryview.selection = nil
                }
            }
        }
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
            UserInterface.space.wipe()
            UserInterface.space.push(PrincipalScreen())
        }))
        
        layers.append(layer)
    }
    
}

class WinScreen: Screen {
    
    override init() {
        super.init()
        
        let layer = InterfaceLayer()
        
        layer.objects.append(TextElement(Camera.size / 2, DynamicText.defaultStyle("You Won!", float4(1), 128)))
        layer.objects.append(TextButton(DynamicText.defaultStyle("Next", float4(1), 86), Camera.size / 2 + float2(0, 400), {
            Score.level += 1
            UserInterface.space.wipe()
            UserInterface.space.push(StoreScreen())
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
    let wave: TextElement
    let points: TextElement
    
    init(_ game: Game) {
        self.game = game
        self.status = game.player
        element = ShieldElement(status.shield)
        wave = TextElement(float2(300, 100), DynamicText.defaultStyle(" ", float4(1), 48.0))
        points = TextElement(float2(Camera.size.x / 2, 60), DynamicText.defaultStyle(" ", float4(1), 72.0))
    }
    
    override func use(_ command: Command) {
       
    }
    
    override func display() {
        element.render()
        wave.setText(DynamicText.defaultStyle("waves: \(game.coordinator.count)", float4(1), 48.0))
        wave.display()
        points.setText(DynamicText.defaultStyle("\(Score.points)", float4(1), 72.0))
        points.display()
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












