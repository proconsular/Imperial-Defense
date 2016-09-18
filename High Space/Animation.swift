//
//  Animation.swift
//  Comm
//
//  Created by Chris Luttio on 8/26/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class TextureAnimation {
    
    var reader: TextureReader
    var timer: Timer!
    var action: (() -> ())?
    
    init (_ rate: Float, _ reader: TextureReader) {
        self.reader = reader
        timer = Timer (rate) { [unowned reader, unowned self] in reader.advance(); self.action?() }
    }
    
    convenience init (_ rate: Float, _ isRepeating: Bool, _ reader: TextureReader) {
        self.init(rate, reader)
        if !isRepeating {
            timer = Timer (rate) { [unowned self, reader] in
                if reader.subframe.index < reader.subframe.limit - 1 {
                    reader.advance()
                    self.action?()
                }
            }
        }
    }
    
    func reset () {
        reader.subframe.index = 0
    }
    
    func face (_ newDirection: Float) {
        reader.setOrientation(float2(newDirection, 1))
    }
    
    func animate (_ amount: Float) {
        timer.update(amount)
    }
    
}
