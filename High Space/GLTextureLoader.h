//
//  TextureLoader.h
//  Imperial Defense
//
//  Created by Chris Luttio on 2/10/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenGLES;
@import CoreGraphics;

@class Texture;

@interface GLTextureLoader : NSObject

+(void)setSampler:(GLuint)sampler;

+(GLuint)createTexture;
+(void *)getImageData:(NSString *)name :(int *)width :(int *)height;

+(void)storeImmutableTexture:(void *)data :(int)width :(int)height :(GLenum)format;

+(void *)convertData:(void *)data :(int)width :(int)height;

+(Texture *)fetch:(NSString *)name;
+(Texture *)fetch:(NSString *)name :(GLenum)format;

@end
