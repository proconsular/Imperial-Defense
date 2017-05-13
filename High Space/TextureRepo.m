//
//  Art.m
//  Imperial Defense
//
//  Created by Chris Luttio on 5/2/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "TextureRepo.h"
#import "GameViewController.h"
#import "GLTextureLoader.h"
#import "Imperial_Defense-Swift.h"

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

    unsigned int pixel_sampler;
    
    glGenSamplers(1, &pixel_sampler);
    glSamplerParameteri(pixel_sampler, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glSamplerParameteri(pixel_sampler, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glSamplerParameteri(pixel_sampler, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glSamplerParameteri(pixel_sampler, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    unsigned int normal_sampler;
    
    glGenSamplers(1, &normal_sampler);
    glSamplerParameteri(normal_sampler, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glSamplerParameteri(normal_sampler, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glSamplerParameteri(normal_sampler, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glSamplerParameteri(normal_sampler, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    [GLTextureLoader setSampler:normal_sampler];
    
    [self prefetch:@"white"];
    [self prefetch:@"bullet"];
    [self prefetch:@"Player"];
    [self prefetch:@"soldier"];
    [self prefetch:@"stonefloor"];
    [self prefetch:@"rockfloor"];
    
    [self prefetch:@"machine"];
    [self prefetch:@"bomb"];
    [self prefetch:@"shield"];
    [self prefetch:@"barrier"];
    [self prefetch:@"castle"];
    [self prefetch:@"GameUIBack"];
    [self prefetch:@"pause"];
    [self prefetch:@"Splash"];
    [self prefetch:@"play_back"];
    [self prefetch:@"coin"];
    [self prefetch:@"gun"];
    [self prefetch:@"Forge"];
    
    [GLTextureLoader setSampler:pixel_sampler];
    
    [self prefetch:@"soldier_walk"];
    [self prefetch:@"Soldier3"];
    [self prefetch:@"NewSoldier"];
    [self prefetch:@"barrier_castle"];
    [self prefetch:@"Crystal"];
    [self prefetch:@"Plates"];
    [self prefetch:@"SaveFile"];
    
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
    return des.id;
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
