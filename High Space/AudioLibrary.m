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
    
    NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:@"wav" inDirectory:@""];
    
    for (NSString *name in files) {
        NSString *reference = [[name componentsSeparatedByString:@"/"] lastObject];
         NSString *fixed = [[reference componentsSeparatedByString:@"."] firstObject];
        if ([reference hasPrefix:@"s_"]) {
            [self loadSound:fixed];
        }
        if ([reference hasPrefix:@"m_"]) {
            [self loadMusic:fixed];
        }
    }
    
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

-(void)loadSound:(NSString *)name{
    @try{
        [_sounds addEntriesFromDictionary:@{[name substringFromIndex:2]: [self loadAudioWithName:name]}];
    }@catch(NSException* e){
        NSLog(@"%@", [e debugDescription]);
    }
}

-(void)loadMusic:(NSString *)name{
    @try{
        [_sounds addEntriesFromDictionary:@{[name substringFromIndex:2]: [self loadAudioWithName:name format:AL_FORMAT_STEREO16 rate:44100]}];
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
