
//
//  Weapon.m
//  LS
//
//  Created by MatLecu on 16/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Weapon.h"
#import "ls_includes.h"
#import "Bullet.h"

@implementation Weapon

-(int)fireCost
{
    return 1;
}

-(NSArray *)fireAt:(CGPoint)touch from:(CGPoint)startLocation inLayer:(CCLayer *)layer
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //compute start and arrive location
    CGPoint destLocation;
    CGPoint direction = ccpNormalize(ccpSub(touch, startLocation));
    
    float ratioX = 0, ratioY = 0;
    if (direction.x > 0)
        ratioX = (winSize.width + OFFSET_FOR_PROJECTILES - startLocation.x) / direction.x;
    else if (direction.x < 0)
        ratioX = (- startLocation.x - OFFSET_FOR_PROJECTILES) / direction.x;
    if (direction.y > 0)
        ratioY = (winSize.height + OFFSET_FOR_PROJECTILES - startLocation.y) / direction.y;
    else if (direction.y < 0)
        ratioY = (- startLocation.y - OFFSET_FOR_PROJECTILES) / direction.y;
    
    float ratio;
    if (ratioX == 0)
        ratio = ratioY;
    else if (ratioY == 0)
        ratio = ratioX;
    else
        ratio = min(ratioX, ratioY);
    
    destLocation = ccpAdd(startLocation, ccpMult(direction, ratio));

    float length = ccpDistance(startLocation, destLocation);
    float velocity = 650/1; // 650pixels/1sec
    float realMoveDuration = length/velocity;
    
    CCSprite *nextProjectile = [Bullet initRandom];
    nextProjectile.tag = 2;
    nextProjectile.position = startLocation;
    [nextProjectile runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:realMoveDuration position:destLocation],
                                [CCCallFuncN actionWithTarget:layer selector:@selector(spriteMoveFinished:)],
                                nil]];
    return [NSArray arrayWithObject:nextProjectile];
}

+(id)weapon {
    Weapon *weapon = nil;
    if ((weapon = [[[super alloc] init] autorelease])) {
    }
    return weapon;
}

@end
