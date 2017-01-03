//
//  Texture.h
//  Imperial Defense
//
//  Created by Chris Luttio on 10/18/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

@import simd;
@import OpenGLES;

@interface Texture : NSObject

@property(nonatomic, readonly) vector_float2 bounds;
@property(readonly) GLuint texture;

-(instancetype)initWithTexture:(GLuint)aTexture bounds:(vector_float2)bounds;

@end
