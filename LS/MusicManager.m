//
//  MusicManager.m
//  LS
//
//  Created by Mathias on 5/3/13.
//  Copyright (c) 2013 Polytechnique. All rights reserved.
//

#import "MusicManager.h"
#import "SimpleAudioEngine.h"

@interface MusicManager () {
    BOOL _musicPlaying;
}

@end

@implementation MusicManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MusicManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - music handling

- (void) changeSound
{
    [self setSound:![[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]];
}

- (void) setSound:(BOOL)onoff
{
    [[NSUserDefaults standardUserDefaults] setBool:onoff forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (onoff) {
        [self startBackgroundMusic];
    } else {
        [self stopBackgroundMusic];
    }
}

- (void) startBackgroundMusic
{
    if (!_musicPlaying && [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique_fond_Mim_suite.mp3"];
        _musicPlaying = YES;
    }
}

- (void) stopBackgroundMusic
{
    if (_musicPlaying) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        _musicPlaying = NO;
    }
}

@end
