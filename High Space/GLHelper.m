//
//  GLHelper.m
//  Imperial Defense
//
//  Created by Chris Luttio on 3/3/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "GLHelper.h"
@import OpenGLES;
#import "GameViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

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

+(GLuint)createFrameBuffer{
    GLuint frame;
    glGenFramebuffers(1, &frame);
    return frame;
}

+(void)bindFrameBuffer:(GLuint)frame{
    glBindFramebuffer(GL_FRAMEBUFFER, frame);
}

+(void)clear{
    glClear(GL_COLOR_BUFFER_BIT);
}

+(void)bindDefaultFramebuffer{
    [glkview bindDrawable];
}

+(void)deleteFramebuffer:(GLuint)frame{
    glDeleteFramebuffers(1, &frame);
}

+(void)deleteTexture:(GLuint)texture{
    glDeleteTextures(1, &texture);
}

+(GLvoid *)createOffset:(int)offset{
    return BUFFER_OFFSET(offset);
}

+(GLfloat *)convertMatrix:(GLKMatrix4)matrix {
    GLfloat *pointer = matrix.m;
    return pointer;
}

@end
