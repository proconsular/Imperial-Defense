//
//  RawVisualDisplay.m
//  Imperial Defence
//
//  Created by Chris Luttio on 12/30/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "GLVisualDisplay.h"
#import "Imperial_Defense-Swift.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation GLVisualDisplay

-(instancetype)init:(id<RawScheme>)scheme{
    self = [super init];
    _scheme = scheme;
    [self setupDisplay];
    return self;
}

-(void)dealloc{
    glDeleteBuffers(1, &_vbo);
    glDeleteBuffers(1, &_ibo);
    glDeleteVertexArrays(1, &_vao);
}

-(void)setupDisplay{
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);

    _vbo = [GLVisualDisplay createBuffer:[_scheme getCompiledBufferData] :[_scheme getCompiledBufferDataSize] :GL_ARRAY_BUFFER :GL_DYNAMIC_DRAW];
    _ibo = [GLVisualDisplay createBuffer:[_scheme getIndices] :[_scheme getIndexBufferSize] :GL_ELEMENT_ARRAY_BUFFER :GL_STATIC_DRAW];
    
    [self setupStates];
}

+(unsigned int)createBuffer:(void *)data :(GLsizeiptr)size :(GLenum)BUFFER_TYPE :(GLenum)RENDER_TYPE{
    unsigned int buffer;
    
    glGenBuffers(1, &buffer);
    glBindBuffer(BUFFER_TYPE, buffer);
    glBufferData(BUFFER_TYPE, size, data, RENDER_TYPE);
    
    free(data);
    return buffer;
}

-(void)setupStates{
    [GLVisualDisplay enable:GLKVertexAttribPosition :2 :GL_FALSE :32 :0];
    [GLVisualDisplay enable:GLKVertexAttribTexCoord0:2 :GL_TRUE  :32 :8];
    [GLVisualDisplay enable:GLKVertexAttribColor    :4 :GL_FALSE :32 :16];
}

+(void)enable:(GLKVertexAttrib)attribute :(int)size :(GLboolean)normalized :(int)stride :(int)offset{
    glEnableVertexAttribArray(attribute);
    glVertexAttribPointer(attribute, size, GL_FLOAT, normalized, stride, BUFFER_OFFSET(offset));
}

-(void)refresh{
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    
    float *newData = [_scheme getCompiledBufferData];
    float *data = glMapBufferRange(GL_ARRAY_BUFFER, 0, [_scheme getCompiledBufferDataSize], GL_MAP_WRITE_BIT | GL_MAP_INVALIDATE_BUFFER_BIT);
    memcpy(data, newData, [_scheme getCompiledBufferDataSize]);
    free(newData);
    
    glUnmapBuffer(GL_ARRAY_BUFFER);
}

-(void)render{
    glBindVertexArray(_vao);
    glBindTexture(GL_TEXTURE_2D, [_scheme getTexture]);
    glUniformMatrix4fv(modelViewProjectionMatrix_Uniform, 1, 0, GLKMatrix4Multiply(projectionMatrix, [_scheme getMatrix]).m);
    
    glDrawElements(GL_TRIANGLE_FAN, [_scheme getIndexBufferSize] / 2, GL_UNSIGNED_SHORT, 0);
}

@end
