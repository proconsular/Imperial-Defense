//
//  Texture.m
//  Bot Bounce
//
//  Created by Chris Luttio on 10/18/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

#import "Texture.h"

@implementation Texture

-(instancetype)initWithTexture:(GLuint)aTexture bounds:(vector_float2)bounds{
    self = [super init];
    _texture = aTexture;
    _bounds = bounds;
    return self;
}

-(void)dealloc{
    glDeleteTextures(1, &_texture);
}

@end