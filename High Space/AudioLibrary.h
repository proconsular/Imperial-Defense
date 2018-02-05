//
//  Audio.h
//  Imperial Defense
//
//  Created by Chris Luttio on 4/18/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
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

-(void)loadSound:(NSString *)sound;
-(void)loadMusic:(NSString *)music;

+(RawAudio *)getAudio:(NSString *)name;

@end
