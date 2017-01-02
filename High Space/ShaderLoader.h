//
//  ShaderLoader.h
//  Imperial Defence
//
//  Created by Chris Luttio on 2/8/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenGLES;

typedef void(^block)(void);

@interface ShaderLoader : NSObject

+(void)load:(NSString *)name :(GLuint *)program :(block)code;
+(GLuint)getShader:(NSString *)name :(GLenum)type;
+(void)removeShader:(GLuint)shader :(GLuint)program;

+(BOOL)compile:(GLuint *)shader :(GLenum)type :(NSString *)file;
+(BOOL)link:(GLuint)prog;
+(BOOL)validate:(GLuint)prog;

@end
