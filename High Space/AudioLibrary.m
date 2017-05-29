//
//  Audio.m
//  Imperial Defense
//
//  Created by Chris Luttio on 4/18/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

#import "AudioLibrary.h"
#import "Imperial_Defense-Swift.h"

@import OpenAL.al;

@implementation AudioLibrary

+ (instancetype)sharedLibrary {
    static AudioLibrary *_sharedLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLibrary = [self new];
    });
    
    return _sharedLibrary;
}

-(instancetype)init{
    self = [super init];
    
    _device = alcOpenDevice(NULL);
    _context = alcCreateContext(_device, NULL);
    alcMakeContextCurrent(_context);
    _sounds = [NSMutableDictionary new];
    
    [self loadAudio:@"hit1"];
    [self loadAudio:@"explosion1"];
    [self loadAudio:@"jump1"];
    [self loadAudio:@"make1"];
    [self loadAudio:@"shield-re1"];
    [self loadAudio:@"shoot1"];
    [self loadAudio:@"shoot2"];
    [self loadAudio:@"shoot3"];
    [self loadAudio:@"shoot4"];
    [self loadAudio:@"hit2"];
    [self loadAudio:@"hit5"];
    [self loadAudio:@"hit4"];
    [self loadAudio:@"hit6"];
    [self loadAudio:@"hit7"];
    [self loadAudio:@"hit8"];
    [self loadAudio:@"charge1"];
    [self loadAudio:@"charge2"];
    [self loadAudio:@"pickup1"];
    [self loadAudio:@"pickup2"];
    [self loadAudio:@"door1"];
    [self loadAudio:@"laser"];
    [self loadAudio:@"laser2"];
    [self loadAudio:@"march1"];
    [self loadAudio:@"break1"];
    [self loadAudio:@"shield_weak"];
    [self loadAudio:@"shield_break"];
    [self loadAudio:@"power_full"];
    [self loadAudio:@"power_low"];
    [self loadAudio:@"death"];
    [self loadAudio:@"barrier_hit"];
    [self loadAudio:@"enemy_hit"];
    [self loadAudio:@"barrier_ruin"];
    [self loadAudio:@"barrier_destroy"];
    [self loadAudio:@"charge"];
    [self loadAudio:@"victory"];
    [self loadAudio:@"enemy_charge"];
    [self loadAudio:@"thunder"];
    [self loadAudio:@"0 Title" :44100];
    [self loadAudio:@"1 Battle" :44100];
    [self loadAudio:@"2 Imperial" :44100];
    [self loadAudio:@"Defeat" :44100];
    
    _hasMusic = YES;
    _hasSound = YES;
    
    return self;
}

-(void)loadAudio:(NSString *)name{
    @try{
        [_sounds addEntriesFromDictionary:@{name: [self loadAudioWithName:name]}];
    }@catch(NSException* e){
        NSLog(@"%@", [e debugDescription]);
    }
}

-(void)loadAudio:(NSString *)name :(unsigned int)rate {
    @try{
        [_sounds addEntriesFromDictionary:@{name: [self loadAudioWithName:name format:AL_FORMAT_STEREO16 rate:rate]}];
    }@catch(NSException* e){
        NSLog(@"%@", [e debugDescription]);
    }
}

+(RawAudio *)getAudio:(NSString *)name{
    return [AudioLibrary sharedLibrary].sounds[name];
}

-(void)dealloc{
    for (NSString* key in _sounds) {
        [self unloadMusicWithName:key];
    }
    [_sounds removeAllObjects];
    [_abo removeAllObjects];
    alcDestroyContext(_context);
    alcCloseDevice(_device);
}

-(void)loadMusicWithName:(NSString *)name{
    [_sounds addEntriesFromDictionary:@{name: [self loadAudioWithName:name format:AL_FORMAT_MONO8 rate:22050]}];
}

-(void)unloadMusicWithName:(NSString *)name{
    RawAudio *audio = _sounds[name];
    ALuint source = audio.source;
    [audio stop];
    
    alSourcei(source, AL_BUFFER, 0);
    alDeleteSources(1, &source);
    
    unsigned int buffer = audio.buffer;
    alDeleteBuffers(1, &buffer);
    
    [_sounds removeObjectForKey:name];
}


-(RawAudio *)loadAudioWithName:(NSString *)name{
    RawAudio *sound = [self loadAudioWithName:name format:AL_FORMAT_STEREO16 rate:22050];
    [sound newVolume:0.3f];
    return sound;
}

-(RawAudio *)loadAudioWithName:(NSString *)name format:(ALuint)format rate:(ALuint)rate{
    
    ALuint source = 0;
    alGenSources(1, &source);
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
    
    AudioFileID afid;
    OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);
    
    if (openAudioFileResult != 0) {
        NSLog(@"An error occurred when attempting to open the audio file %@: %d", audioFilePath, (int)openAudioFileResult);
        return 0;
    }
    
    UInt64 audioDataByteCount = 0;
    UInt32 propertySize = sizeof(audioDataByteCount);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataByteCount);
    if (getSizeResult != 0) {
        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %d", audioFilePath, (int)getSizeResult);
    }
    
    UInt32 bytesRead = (UInt32)audioDataByteCount;
    void* audioData = malloc(bytesRead);
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    if (readBytesResult != 0) {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %d", audioFilePath, (int)readBytesResult);
    }
    
    AudioFileClose(afid);
    ALuint outputBuffer;
    alGenBuffers(1, &outputBuffer);
    alBufferData(outputBuffer, format, audioData, bytesRead, rate);
    
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
    
    alSourcei(source, AL_BUFFER, outputBuffer);
    
    return [[RawAudio alloc] init:source :outputBuffer];
}

@end
