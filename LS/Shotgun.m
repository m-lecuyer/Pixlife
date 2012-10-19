//
//  Shotgun.m
//  LS
//
//  Created by MatLecu on 16/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Shotgun.h"
#import "ls_includes.h"
#import "Bullet.h"

@implementation Shotgun

@synthesize maxSpeed = _maxSpeed;
@synthesize minSpeed = _minSpeed;

-(int)fireCost
{
    return NUMNER_OF_BULLETS_SHOTGUN;
}

-(NSArray *)fireAt:(CGPoint)touch from:(CGPoint)startLocation inLayer:(CCLayer *)layer
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //compute start and arrive location
    CGPoint destLocation;
    CGPoint mainDirection = ccpNormalize(ccpSub(touch, startLocation));
    
    int rangeV = self.maxSpeed - self.minSpeed;
    float velocity;

    NSMutableArray *bullets = [NSMutableArray array];
    for (int i = 0; i < NUMNER_OF_BULLETS_SHOTGUN; i++) {
        velocity = (arc4random() % rangeV) + self.minSpeed;
        
        float thetaOffset = ((float)i - (float)NUMNER_OF_BULLETS_SHOTGUN / (float)2) * (0.2 / (float)NUMNER_OF_BULLETS_SHOTGUN);
        CGPoint direction;
        direction.x = cos(thetaOffset) * mainDirection.x - sin(thetaOffset) * mainDirection.y;
        direction.y = sin(thetaOffset) * mainDirection.x + cos(thetaOffset) * mainDirection.y;
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
        float realMoveDuration = length/velocity;
        
        CCSprite *nextProjectile = [Bullet initRandom];
        nextProjectile.tag = 2;
        nextProjectile.position = startLocation;
        [nextProjectile runAction:[CCSequence actions:
                                   [CCMoveTo actionWithDuration:realMoveDuration position:destLocation],
                                   [CCCallFuncN actionWithTarget:layer selector:@selector(spriteMoveFinished:)],
                                   nil]];
        [bullets addObject:nextProjectile];
    }
    
    return bullets;
}

+(id)weapon {
    Shotgun *weapon = nil;
    if ((weapon = [[[super alloc] init] autorelease])) {
        weapon.maxSpeed = 650/1;
        weapon.minSpeed = 400/1;
    }
    return weapon;
}

@end
