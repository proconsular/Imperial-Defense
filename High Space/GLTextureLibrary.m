//
//  Art.m
//  Imperial Defense
//
//  Created by Chris Luttio on 5/2/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "GLTextureLibrary.h"
#import "GameViewController.h"
#import "GLTextureLoader.h"
#import "Imperial_Defense-Swift.h"

@implementation GLTextureLibrary

+ (instancetype)sharedLibrary {
    static GLTextureLibrary  *restrict _sharedLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLibrary = [self new];
    });
    return _sharedLibrary;
}

-(instancetype)init{
    self = [super init];
    
    _textures = [NSMutableDictionary new];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    [self loadAllTextures];
    
    return self;
}

-(void)loadAllTextures {
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    
    [self prefetch:@"laser"];
    [self prefetch:@"white"];
    [self prefetch:@"bullet"];
    [self prefetch:@"Player"];
    [self prefetch:@"stonefloor"];
    [self prefetch:@"rockfloor"];
    
    [self prefetch:@"GameUIBack"];
    [self prefetch:@"pause"];
    [self prefetch:@"Splash_Foreground"];
    [self prefetch:@"Splash_Cloud_1"];
    [self prefetch:@"Splash_Cloud_2"];
    [self prefetch:@"Splash_Cloud_3"];
    [self prefetch:@"Splash_Cloud_4"];
    [self prefetch:@"Splash_FarCliffs"];
    
    [self prefetch:@"Forge-Back"];
    [self prefetch:@"Forge-Brick"];
    [self prefetch:@"Title"];
    
    [self prefetch:@"ShowInput-Base"];
    [self prefetch:@"ShowInput-Case"];
    [self prefetch:@"ShowPointer"];
    [self prefetch:@"Missile"];
    
    [self prefetch:@"Soldier4"];
    [self prefetch:@"Scout"];
    [self prefetch:@"Captain"];
    [self prefetch:@"Warrior"];
    [self prefetch:@"Thief"];
    [self prefetch:@"Heavy"];
    [self prefetch:@"barrier_castle"];
    [self prefetch:@"Crystal"];
    [self prefetch:@"Plates"];
    [self prefetch:@"SaveFile"];
    [self prefetch:@"Treasure"];
    [self prefetch:@"Mage"];
    [self prefetch:@"Emperor"];
    [self prefetch:@"Titan"];
    [self prefetch:@"ArmoredSoldier"];
    [self prefetch:@"ArmoredScout"];
    [self prefetch:@"HardSoldier"];
    [self prefetch:@"Castle-Centerpiece"];
    [self prefetch:@"Castle-Rightpiece"];
    [self prefetch:@"Castle-Leftpiece"];
    [self prefetch:@"Rubble"];
    [self prefetch:@"Upgrades"];
    [self prefetch:@"Upgrade_Effects"];
    [self prefetch:@"UpgradeBorder"];
    [self prefetch:@"ButtonBorder"];
    [self prefetch:@"Background"];
    [self prefetch:@"Halo"];
    
    
}

+(void)deleteTexture:(NSString *)texture{
    [[GLTextureLibrary sharedLibrary].textures removeObjectForKey:texture];
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
