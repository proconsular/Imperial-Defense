//
//  GLHelper.m
//  Imperial Defense
//
//  Created by Chris Luttio on 3/3/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "GLHelper.h"
@import OpenGLES;

@implementation GLHelper

+(GLuint)createVertexArray{
    GLuint array;
    glGenVertexArraysOES(1, &array);
    return array;
}

+(void)deleteVertexArray:(GLuint)array{
    glDeleteVertexArraysOES(1, &array);
}

+(GLuint)createBuffer {
    GLuint buffer;
    glGenBuffers(1, &buffer);
    return buffer;
}

+(void)deleteBuffer:(GLuint)buffer{
    glDeleteBuffers(1, &buffer);
}

@end
