//
//  ShaderLoader.m
//  Imperial Defense
//
//  Created by Chris Luttio on 2/8/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "ShaderLoader.h"

@implementation ShaderLoader

+(void)load:(NSString *)name :(GLuint *)program :(block)bindings{
    *program = glCreateProgram();
    
    GLuint vertex = [ShaderLoader getShader:name :GL_VERTEX_SHADER];
    GLuint fragment = [ShaderLoader getShader:name :GL_FRAGMENT_SHADER];
    
    glAttachShader(*program, vertex);
    glAttachShader(*program, fragment);
    
    bindings();
    
    [ShaderLoader link:*program];
    
    [ShaderLoader removeShader:vertex :*program];
    [ShaderLoader removeShader:fragment :*program];
}

+(GLuint)getShader:(NSString *)name :(GLenum)type{
    GLuint shader;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType: type == GL_VERTEX_SHADER ? @"vsh" : @"fsh"];
    if (![ShaderLoader compile:&shader :type :path]) {
        NSLog(@"Failed to compile shader");
    }
    return shader;
}

+(void)removeShader:(GLuint)shader :(GLuint)program{
    glDetachShader(program, shader);
    glDeleteShader(shader);
}

+(BOOL)compile:(GLuint *)shader :(GLenum)type :(NSString *)file{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

+(BOOL)link:(GLuint)prog{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

+(BOOL)validate:(GLuint)prog{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
