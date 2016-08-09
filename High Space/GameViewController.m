//
//  GameViewController.m
//  eMotion Book
//
//  Created by Chris Luttio on 1/5/15.
//  Copyright (c) 2015 FishyTale Digital, Inc. All rights reserved.
//

#import "GameViewController.h"
#import "Bridge.h"
#import "Sky_s_Melody-Swift.h"
#import "Shader.h"
#import "ShaderLoader.h"

@import OpenGLES;

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

GLKMatrix4 projectionMatrix;
GLint modelViewProjectionMatrix_Uniform;

@implementation GameViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [EAGLContext setCurrentContext:self.context];
    
    [self setPreferredFramesPerSecond:60];
    
    [self setupGL];
}

- (void)dealloc{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL{
    [self setupShaders];
    [self setGraphicsState];
    [self setProjectionMatrix];
    [self setInteractionRecognizers];
    [Bridge create];
}

-(void)setupShaders{
    [ShaderLoader load:@"Default" :&_defaultprogram :^{
        glBindAttribLocation(_defaultprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(_defaultprogram, GLKVertexAttribColor, "color");
        glBindAttribLocation(_defaultprogram, GLKVertexAttribTexCoord0, "texCoord0");
    }];
    
    [ShaderLoader load:@"Lighting" :&_lightingprogram :^{
        glBindAttribLocation(_lightingprogram, GLKVertexAttribPosition, "position");
    }];
    
    Shader *light = [[Shader alloc] initAsProgram:_lightingprogram];
    
    [light addProperties:
  @[@"light.location",
    @"light.color",
    @"light.brightness",
    @"light.attenuation",
    @"light.temperature",
    @"light.dissipation",
    @"count"]];
    
    for (int n = 0; n < 10; n++) {
        [light addProperties:
         @[[NSString stringWithFormat:@"faces[%d].first", n],
           [NSString stringWithFormat:@"faces[%d].second", n],
           [NSString stringWithFormat:@"faces[%d].center", n]]];
    }
    
    [Graphics append:[[Shader alloc] initAsProgram:_defaultprogram]];
    [Graphics append:light];
    
    modelViewProjectionMatrix_Uniform = glGetUniformLocation(_defaultprogram, "modelViewProjectionMatrix");
    
    glUniform1i(glGetUniformLocation(_defaultprogram, "Texture0"), 0);
    glUseProgram(_defaultprogram);
}

-(void)setGraphicsState{
    glEnable(GL_TEXTURE_2D);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    glActiveTexture(GL_TEXTURE0);
    
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
}

-(void)setProjectionMatrix{
    int width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    int height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    
    double scale = 1;
    projectionMatrix = GLKMatrix4MakeOrtho(-width * (scale - 1), width * scale, height * scale, -height * (scale - 1), 1, -1);
}

-(void)setInteractionRecognizers{
    Interaction *rightSide = [[Interaction alloc] initWithTarget:self action:nil];
    Interaction *leftSide = [[Interaction alloc] initWithTarget:self action:nil];
    
    [self.view addGestureRecognizer:rightSide];
    [self.view addGestureRecognizer:leftSide];
    
    [Interaction appendTouch:rightSide];
    [Interaction appendTouch:leftSide];
}

-(void)tearDownGL{
    [EAGLContext setCurrentContext:self.context];

    if (_defaultprogram) {
        glDeleteProgram(_defaultprogram);
        _defaultprogram = 0;
    }
}

-(void)update{
    [[Bridge sharedInstance] update:self.timeSinceLastUpdate];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT);
    [[Bridge sharedInstance] display];
}

@end
