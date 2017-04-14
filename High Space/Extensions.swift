//
//  extensions.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/16/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    
    mutating func removeObject(_ element: Element) {
        for n in 0 ..< self.count {
            if self[n] === element {
                self.remove(at: n)
                return
            }
        }
    }
    
}

extension Int {
    var roman: String {
        var integerValue = self
        var numeralString = ""
        let mappingList: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        for i in mappingList where (integerValue >= i.0) {
            while (integerValue >= i.0) {
                integerValue -= i.0
                numeralString.append(i.1)
            }
        }
        return numeralString
    }
}
