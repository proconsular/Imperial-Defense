//
//  RenderableShape.swift
//  Relaci
//
//  Created by Chris Luttio on 9/13/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

func coordinatesFromIndex (_ index: Float, _ width: Float) -> float2 {
    return float2 (index.truncatingRemainder(dividingBy: width), Float(Int(index / width)))
}

extension int2 {
    var anglize: Float {
        return (Float(x) / Float(y)) * Float(M_PI * 2)
    }
    
    init (_ x: Int, _ y: Int) {
        self.init(Int32(x), Int32(y))
    }
}

func + (vector: float2, scalar: Float) -> float2 {
    return float2(vector.x + scalar, vector.y + scalar)
}

func - (vector: float2, scalar: Float) -> float2 {
    return vector + -scalar
}

func * (alpha: float2, beta: float2) -> float2 {
    return float2(alpha.x * beta.x, alpha.y * beta.y)
}

func generateTextureCoordinates (_ offset: float2, _ frame: float2) -> [float2] {
    var textureCoordinates = [float2] ()
    for i in 0 ..< 4 {
        textureCoordinates.append((float2.polar(int2(i, 4).anglize - 45.toRadians) / 1.5 + 0.5) * frame + offset)
    }
    return textureCoordinates
}

class TextureReader {
    
    struct Subframe {
        let frame: float2
        let stride, limit: Float
        var orientation: float2
        var index: Float
        
        init (_ frame: float2, _ bounds: float2, _ stride: Float, _ limit: Float) {
            self.frame = frame / bounds
            self.stride = stride
            self.limit = limit
            orientation = float2(1)
            index = 0
        }
        
        func getCoordinates () -> float2 {
            return coordinatesFromIndex(index, stride)
        }
        
        func getTextureCoordinates () -> [float2] {
            var offset = float2()
            if orientation.x == -1 {
                offset.x = 1
            }
            return generateTextureCoordinates((getCoordinates() + offset) * frame, frame * orientation)
        }
        
        mutating func advance () {
            index ++% limit
        }
        
    }
    
    let rawTexture: Texture
    var subframe: Subframe
    
    init (_ frame: float2, _ stride: Float, _ limit: Float, _ texture: Texture) {
        subframe = Subframe (frame, texture.bounds, stride, limit)
        rawTexture = texture
    }
    
    func advance () {
        subframe.advance()
    }
    
    func setOrientation (_ newOrientation: float2) {
        subframe.orientation = newOrientation
    }
    
    func getTexture () -> GLuint {
        return rawTexture.texture
    }
    
    func getCoordinates() -> [float2] {
        return subframe.getTextureCoordinates()
    }
    
    func getTextureCoordinatesPointer () -> UnsafeMutablePointer<Float> {
        return subframe.getTextureCoordinates().asFloatData()
    }
    
}
