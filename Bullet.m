//
//  Bullet.m
//  LS
//
//  Created by MatLecu on 27/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Bullet.h"
#import "ls_includes.h"

@implementation Bullet

+(id)initRandom
{
    Bullet *b = [Bullet alloc];
    NSString *filename;
    RANDOM_PIXLIFE(filename);
    if ((b = [b initWithFile:filename])) {
    }
    return b;
}

-(id)initWithFile:(NSString *)filename
{
    if (self = [super initWithFile:filename]) {
    }
    return self;
}

@end
