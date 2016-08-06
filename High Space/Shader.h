//
//  Shader.h
//  Raeximu
//
//  Created by Chris Luttio on 9/23/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

typedef void(^BindingBlock)(NSMutableDictionary *);

@interface Shader : NSObject

@property(readonly) GLuint program;
@property(readonly) NSMutableDictionary *bindings;

-(instancetype)initAsProgram:(GLuint)program;

-(void)addProperty:(NSString *)name;
-(void)addProperties:(NSArray<NSString *> *)names;
-(Shader *)bind;

-(Shader *)setProperty:(NSString *)name value:(float)value;
-(Shader *)setProperty:(NSString *)name intvalue:(int)value;
-(Shader *)setProperty:(NSString *)name vector2:(vector_float2)value;
-(Shader *)setProperty:(NSString *)name vector4:(vector_float4)value;
-(Shader *)setProperty:(NSString *)name mat4:(GLKMatrix4)mat;
-(Shader *)setProperties:(NSDictionary *)properties;

@end
