//
//  GameViewController.h
//  eMotion Book
//
//  Created by Chris Luttio on 1/5/15.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

@import UIKit;
@import GLKit;
@import OpenGLES;

extern GLKMatrix4 projectionMatrix;
extern GLint modelViewProjectionMatrix_Uniform;

typedef void(^block)(void);

@interface GameViewController : GLKViewController

@property GLuint defaultprogram, lightingprogram;
@property (strong, nonatomic) EAGLContext *context;

-(void)setupGL;
-(void)tearDownGL;

-(void)setupShaders;
-(void)setGraphicsState;
-(void)setProjectionMatrix;
-(void)setInteractionRecognizers;

@end
