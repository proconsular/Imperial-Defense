//
//  Shader.m
//  Raeximu
//
//  Created by Chris Luttio on 9/23/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import "Shader.h"

@implementation Shader

-(instancetype)initAsProgram:(GLuint)program{
    self = [super init];
    
    _program = program;
    _bindings = [NSMutableDictionary new];
    
    return self;
}

-(void)addProperties:(NSArray<NSString *> *)names{
    for (NSString *name in names) {
        [self addProperty:name];
    }
}

-(void)addProperty:(NSString *)name {
    _bindings[name] = @(glGetUniformLocation(_program, [name UTF8String]));
}

-(Shader *)bind {
    glUseProgram(_program);
    return self;
}

-(Shader *)setProperties:(NSDictionary *)properties{
    for (NSString *key in properties.allKeys) {
        [self setProperty:key value:[properties[key] floatValue]];
    }
    return self;
}

-(Shader *)setProperty:(NSString *)name value:(float)value{
    int location = [_bindings[name] intValue];
    glUniform1f(location, value);
    return self;
}

-(Shader *)setProperty:(NSString *)name intvalue:(int)value{
    int location = [_bindings[name] intValue];
    glUniform1i(location, value);
    return self;
}

-(Shader *)setProperty:(NSString *)name vector2:(vector_float2)value{
    int location = [_bindings[name] intValue];
    glUniform2f(location, value.x, value.y);
    return self;
}

-(Shader *)setProperty:(NSString *)name vector4:(vector_float4)value{
    int location = [_bindings[name] intValue];
    glUniform4f(location, value.x, value.y, value.z, value.w);
    return self;
}

-(Shader *)setProperty:(NSString *)name mat4:(GLKMatrix4)mat{
    int location = [_bindings[name] intValue];
    glUniformMatrix4fv(location, 1, 0, mat.m);
    return self;
}

@end
