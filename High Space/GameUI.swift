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
        
        let game = Game()
        
        layers.append(game)
    }
    
    override func use(command: Command) {
        layers.reverse().forEach{ $0.use(command) }
    }
    
    override func display() {
        layers.forEach{$0.display()}
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