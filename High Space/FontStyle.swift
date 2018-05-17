//
//  FontStyle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
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
    
    var attributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): fontFamily, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): fontColor]
    }
    
    var fontFamily: UIFont {
        return UIFont(name: font, size: CGFloat(size))!
    }
    
    var fontColor: UIColor {
        return UIColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: CGFloat(color.w))
    }
}
