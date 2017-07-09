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

class Text: InterfaceElement {
    var string: String
    var style: FontStyle
    var text: DynamicText
    var bounds: float2 = float2()
    
    convenience init(_ style: FontStyle) {
        self.init(" ", style)
    }
    
    init(_ string: String, _ style: FontStyle = defaultStyle) {
        self.string = string
        self.style = style
        self.text = DynamicText(attributedString: Text.computeString(string, style))
    }
    
    init(_ string: String, _ style: FontStyle, _ bounds: float2) {
        self.string = string
        self.style = style
        self.bounds = bounds
        self.text = DynamicText(attributedString: Text.computeString(string, style), bounds: bounds)
    }
    
    convenience init(_ location: float2, _ string: String, _ style: FontStyle, _ bounds: float2) {
        self.init(string, style, bounds)
        self.location = location
    }
    
    convenience init(_ location: float2, _ string: String, _ style: FontStyle) {
        self.init(string, style)
        self.location = location
    }
    
    private static func computeString(_ string: String, _ style: FontStyle) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: style.attributes)
    }
    
    func setString(_ string: String) {
        guard self.string != string else { return }
        self.string = string
        if bounds.x != 0 && bounds.y != 0 {
             text.create(with: Text.computeString(string, style), bounds: bounds)
        }else{
            text.create(with: Text.computeString(string, style))
        }
    }
    
    var size: float2 {
        return float2(Float(text.attrString.size().width), Float(text.attrString.size().height))
    }
    
    var location: float2 {
        get { return text.location }
        set { text.location = newValue }
    }
    
    var color: float4 {
        get { return text.display.color }
        set { text.display.color = newValue }
    }
    
    func render() {
        text.render()
    }
}







