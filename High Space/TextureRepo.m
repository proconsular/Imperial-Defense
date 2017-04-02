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

    glGenSamplers(1, &_sampler);
    glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glSamplerParameteri(_sampler, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glSamplerParameteri(_sampler, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    [GLTextureLoader setSampler:_sampler];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    NSArray<NSString *> *prefetched =
  @[@"white",
    @"galaxy",
    @"Spawner",
    @"Floater",
    @"Colony",
    @"bullet",
    @"player",
    @"soldier",
    @"stonefloor",
    @"rockfloor",
    @"coin",
    @"armor",
    @"adv_soldier",
    @"laser_soldier",
    @"soldier_walk",
    @"gun",
    @"machine",
    @"bomb",
    @"shield",
    @"movement",
    @"barrier",
    @"castle",
    @"GameUIBack",
    @"pause",
    @"Splash",
    @"play_back"];
    
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
