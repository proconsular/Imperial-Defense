//
//  RawVisualDisplay.h
//  Imperial Defense
//
//  Created by Chris Luttio on 12/30/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@protocol VisualDisplay

-(void)refresh;
-(void)render;

@end

@protocol RawScheme

-(Float32 *)getCompiledBufferData;
-(int)getCompiledBufferDataSize;

-(UInt16 *)getIndices;
-(int)getIndexBufferSize;

-(GLuint)getTexture;
-(GLKMatrix4)getMatrix;

@end
