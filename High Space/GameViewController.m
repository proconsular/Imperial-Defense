//
//  GameViewController.m
//  Imperial Defense
//
//  Created by Chris Luttio on 1/5/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "GameViewController.h"
#import "Bridge.h"
#import "Imperial_Defense-Swift.h"
#import "Shader.h"
#import "ShaderLoader.h"

@import OpenGLES;

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

GLKMatrix4 projectionMatrix;
GLint modelViewProjectionMatrix_Uniform;
GLKView *glkview;

@implementation GameViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    glkview = view;
    
    [EAGLContext setCurrentContext:self.context];
    
    [self setPreferredFramesPerSecond:60];
    
    [self setupGL];
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
        glBindAttribLocation(self->_defaultprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(self->_defaultprogram, GLKVertexAttribColor, "color");
        glBindAttribLocation(self->_defaultprogram, GLKVertexAttribTexCoord0, "texCoord0");
    }];
    
    [ShaderLoader load:@"Lighting" :&_lightingprogram :^{
        glBindAttribLocation(self->_lightingprogram, GLKVertexAttribPosition, "position");
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
    
    [ShaderLoader load:@"Shield" :&_shieldprogram :^{
        glBindAttribLocation(self->_shieldprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(self->_shieldprogram, GLKVertexAttribTexCoord0, "texCoord0");
    }];
    
    Shader *shield = [[Shader alloc] initAsProgram:_shieldprogram];
    
    [shield addProperty:@"color"];
    [shield addProperty:@"location"];
    [shield addProperty:@"level"];
    
    [Graphics append:shield];
    
    [ShaderLoader load:@"Bloom" :&_bloomprogram :^{
        glBindAttribLocation(self->_bloomprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(self->_bloomprogram, GLKVertexAttribTexCoord0, "texCoord0");
    }];
    
    [ShaderLoader load:@"Laser" :&_laserprogram :^{
        glBindAttribLocation(self->_laserprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(self->_laserprogram, GLKVertexAttribTexCoord0, "texCoord0");
    }];
    
    Shader *laser = [[Shader alloc] initAsProgram:_laserprogram];
    
    [laser addProperty:@"color"];
    
    [Graphics append:laser];
    
    Shader *bloom_shader = [[Shader alloc] initAsProgram:_bloomprogram];
    
    [bloom_shader addProperty:@"color"];
    [bloom_shader addProperty:@"quality"];
    [bloom_shader addProperty:@"size"];
    
    [Graphics append:bloom_shader];
    
    [ShaderLoader load:@"Point" :&_pointprogram :^{
        glBindAttribLocation(self->_pointprogram, GLKVertexAttribPosition, "position");
        glBindAttribLocation(self->_pointprogram, GLKVertexAttribNormal, "size");
        glBindAttribLocation(self->_pointprogram, GLKVertexAttribColor, "color");
    }];
    
    Shader *point = [[Shader alloc] initAsProgram:_pointprogram];
    
    [Graphics append:point];
    
    [ShaderLoader load:@"Explosion" :&_explosionprogram :^{
        glBindAttribLocation(self->_explosionprogram, GLKVertexAttribPosition, "position");
    }];
    
    Shader *explosion = [[Shader alloc] initAsProgram:_explosionprogram];
    
    [explosion addProperty:@"color"];
    [explosion addProperty:@"location"];
    [explosion addProperty:@"radius"];
    
    [Graphics append:explosion];
    
    
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
    
    glEnable(GL_CULL_FACE);
    
    glEnable(GL_POINT_SPRITE_OES);
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

-(void)setProjectionMatrix{
    int width = 2001;// [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    int height = 1125;//[UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    
    //float s = 2001 / (float)width;
    
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

-(void)update{
    [Time set:self.timeSinceLastUpdate];
    [[Bridge sharedInstance] update];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT);
    [[Bridge sharedInstance] display];
}

- (void)dealloc{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

-(void)tearDownGL{
    [EAGLContext setCurrentContext:self.context];
    
    if (_defaultprogram) {
        glDeleteProgram(_defaultprogram);
        _defaultprogram = 0;
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

@end
