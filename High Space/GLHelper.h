//
//  GLHelper.h
//  Imperial Defense
//
//  Created by Chris Luttio on 3/3/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface GLHelper : NSObject

+(GLuint)createVertexArray;
+(void)deleteVertexArray:(GLuint)array;

+(GLuint)createBuffer;
+(void)deleteBuffer:(GLuint)buffer;

+(GLuint)createFrameBuffer;
+(void)bindFrameBuffer:(GLuint)frame;

+(void)clear;
+(void)bindDefaultFramebuffer;

+(void)deleteFramebuffer:(GLuint)frame;
+(void)deleteTexture:(GLuint)texture;

+(GLvoid *)createOffset:(int)offset;
+(GLfloat *)convertMatrix:(GLKMatrix4)matrix;

@end
