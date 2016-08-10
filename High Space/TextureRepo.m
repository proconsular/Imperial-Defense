//
//  Art.m
//  Bot Bounce
//
//  Created by Chris Luttio on 5/2/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

#import "TextureRepo.h"
#import "GameViewController.h"
#import "Texture.h"
#import "GLTextureLoader.h"

@implementation TextureRepo

+ (instancetype)sharedLibrary {
    static TextureRepo  *restrict _sharedLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLibrary = [self new];
    });
    
    return _sharedLibrary;
}

-(instancetype)init{
    self = [super init];
    
    _textures = [NSMutableDictionary new];

    glGenSamplers(1, &_sampler);
    glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glSamplerParameteri(_sampler, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glSamplerParameteri(_sampler, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    [GLTextureLoader setSampler:_sampler];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    NSArray<NSString *> *prefetched =
  @[@"white",];
    
    for (NSString *name in prefetched) {
        [self prefetch:name];
    }
    
    return self;
}

+(void)deleteTexture:(NSString *)texture{
    [[TextureRepo sharedLibrary].textures removeObjectForKey:texture];
}

+(void)unloadTexture:(GLuint)texture{
    glDeleteTextures(1, &texture);
}

-(BOOL)doesHaveTexture:(NSString *)name{
    return [_textures objectForKey:name] != nil;
}

-(GLuint)textureWithName:(NSString *)name{
    Texture *des = _textures[name];
    return des.texture;
}

-(Texture *)descriptionWithName:(NSString *)name {
    return _textures[name];
}

-(id)objectForKeyedSubscript:(id)key{
    return _textures[key];
}

-(void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key{
    _textures[key] = obj;
}

-(void)prefetch:(NSString *)name{
    [_textures setObject:[GLTextureLoader fetch:name :GL_RGBA8] forKey:name];
}

@end
