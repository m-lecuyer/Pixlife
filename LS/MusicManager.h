//
//  MusicManager.h
//  LS
//
//  Created by Mathias on 5/3/13.
//  Copyright (c) 2013 Polytechnique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject {
}

+ (id)sharedManager;

- (void) changeSound;
- (void) setSound:(BOOL)onoff;
- (void) startBackgroundMusic;
- (void) stopBackgroundMusic;

@end
