//
//  TextureProvider.h
//  Imperial Defense
//
//  Created by Chris Luttio on 1/31/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@protocol TextureProvider <NSObject>

-(GLuint)lookup:(NSString *)name;

@end
