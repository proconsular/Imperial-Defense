//
//  Audio.h
//  Bot Bounce
//
//  Created by Chris Luttio on 4/18/14.
//  Copyright (c) 2014 Evans Creative Studios. All rights reserved.
//

@import Foundation;
@import OpenAL;
@import OpenAL.alc;
@import AudioToolbox;

@class RawAudio;

@interface AudioLibrary : NSObject

@property NSMutableDictionary *sounds, *abo;
@property ALCdevice *device;
@property ALCcontext *context;

@property (nonatomic) bool hasSound, hasMusic;

+(instancetype)sharedLibrary;

-(void)loadMusicWithName:(NSString*)name;
-(void)unloadMusicWithName:(NSString*)name;

-(RawAudio *)loadAudioWithName:(NSString*)name;
-(RawAudio *)loadAudioWithName:(NSString*)name format:(unsigned int)format rate:(unsigned int)rate;

-(void)loadAudio:(NSString *)name;
-(void)loadAudio:(NSString *)name :(unsigned int)rate;

+(RawAudio *)getAudio:(NSString *)name;

@end
