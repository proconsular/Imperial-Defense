//
//  RawVisualDisplay.h
//  Imperial Defense
//
//  Created by Chris Luttio on 12/30/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RawVisualDisplay.h"

@import GLKit;

@class RawVisualScheme;

@interface GLVisualDisplay : NSObject <VisualDisplay>

@property id<RawScheme> scheme;
@property GLuint vao, vbo, ibo;

-(instancetype)init:(id<RawScheme>)scheme;

-(void)setupDisplay;
-(void)setupStates;

+(unsigned int)createBuffer:(void *)data :(GLsizeiptr)length :(GLenum)BUFFER_TYPE :(GLenum)RENDER_TYPE;
+(void)enable:(GLKVertexAttrib)attribute :(int)stride :(GLboolean)normalized :(int)span :(int)offset;

@end
