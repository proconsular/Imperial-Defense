//
//  Art.h
//  Bot Bounce
//
//  Created by Chris Luttio on 5/2/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

@import GLKit;
@import OpenGLES;

@class Texture;

@interface TextureRepo : NSObject

@property NSMutableDictionary<NSString *, Texture *> *textures;
@property GLuint sampler;

+(instancetype)sharedLibrary;

-(void)prefetch:(NSString *)name;

-(BOOL)doesHaveTexture:(NSString *)name;

-(GLuint)textureWithName:(NSString *)name;
-(Texture *)descriptionWithName:(NSString *)name;

+(void)deleteTexture:(NSString *)texture;
+(void)unloadTexture:(GLuint)texture;

@end
