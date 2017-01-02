//
//  Text.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 1/1/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct FontStyle {
    var font: String
    var color: float4
    var size: Float
    
    init(_ font: String, _ color: float4, _ size: Float) {
        self.font = font
        self.color = color
        self.size = size
    }
    
    var attributes: [String: Any?] {
        return [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: fontColor]
    }
    
    var fontFamily: UIFont {
        return UIFont(name: font, size: CGFloat(size))!
    }
    
    var fontColor: UIColor {
        return UIColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: CGFloat(color.w))
    }
}

class Text {
    var string: String
    var style: FontStyle
    var text: DynamicText
    
    init(_ string: String, _ style: FontStyle) {
        self.string = string
        self.style = style
        self.text = DynamicText(attributedString: Text.computeString(string, style))
    }
    
    init(_ string: String, _ style: FontStyle, _ bounds: float2) {
        self.string = string
        self.style = style
        self.text = DynamicText(attributedString: Text.computeString(string, style), bounds: bounds)
    }
    
    private static func computeString(_ string: String, _ style: FontStyle) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: style.attributes)
    }
    
    func setString(_ string: String) {
        guard self.string != string else { return }
        self.string = string
        text.create(with: Text.computeString(string, style))
    }
    
    var size: float2 {
        return float2(Float(text.attrString.size().width), Float(text.attrString.size().height))
    }
    
    var location: float2 {
        get { return text.location }
        set { text.location = newValue }
    }
    
    func render() {
        text.render()
    }
}







