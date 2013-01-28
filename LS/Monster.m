//
//  Monster.m
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Monster.h"
#import "Character.h"
#import "Ammunition.h"
#import "BasicLevelScene.h"
#import "ls_includes.h"
#import "SimpleAudioEngine.h"
#import "MonsterShoot.h"

@implementation Monster

@synthesize hpBase = _hpBase;
@synthesize hp = _curHp;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

-(void)youRDeadInLayer:(GameLevelLayer *)layer
{
    for (int i = 0; i < AMMO_FOR_MONSTER_DEATH + self.hpBase; i++) {
        Ammunition *ammo = [Ammunition initRandom];
        ammo.position = self.position;
        int vx = arc4random() % 300 - 150;
        int vy = arc4random() % 150;
        ammo.velocity = ccp(vx, vy);
        [layer addChild:ammo];
        [layer.ammunitions addObject:ammo];
    }
    layer.player.ammoTot += AMMO_FOR_MONSTER_DEATH + self.hpBase;
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.mp3"];
    [layer removeChild:self cleanup:YES];
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = self.contentSize.height/2;
    int maxY = winSize.height - self.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(winSize.width + (self.contentSize.width/2), actualY);
    [layer addChild:self];
    
    // Determine speed of the target
    int minDuration = self.minMoveDuration; //2.0;
    int maxDuration = self.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-self.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    [self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

+(Monster*) generateMonsterForLevel:(int)lvl
{
    Monster *target = nil;
    int mLvl = arc4random() % lvl;
    int mType;
    switch (mLvl) {
        case 0:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [WeakAndFastMonster monster];
                    break;
                case 1:
                    target = [StrongAndSlowMonster monster];
                    break;
            }
            break;
        case 1:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [WeakAndFastMonster monster];
                    break;
                case 1:
                    target = [RunningMonster monster];
                    break;
            }
            break;
        case 2:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [FiringMonster monster];
                    break;
                case 1:
                    target = [RunningMonster monster];
                    break;
            }
            break;
        case 3:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [RunningMonsterStrong monster];
                    break;
                case 1:
                    target = [FiringMonster monster];
                    break;
            }
            break;
        case 4:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [RunningMonsterStrong monster];
                    break;
                case 1:
                    target = [FiringMonsterStrong monster];
                    break;
            }
            break;
        case 5:
            mType = arc4random() % 2;
            switch (mType) {
                case 0:
                    target = [FollowingMonster monster];
                    break;
                case 1:
                    target = [FiringMonsterStrong monster];
                    break;
            }
            break;
        case 6:
            target = [FollowingMonster monster];
            break;
        default:
            mType = arc4random() % 5;
            switch (mType) {
                case 0:
                    target = [FollowingMonster monster];
                    break;
                case 1:
                    target = [FiringMonsterStrong monster];
                    break;
                case 2:
                    target = [RunningMonsterStrong monster];
                    break;
                case 3:
                    target = [FiringMonster monster];
                    break;
                case 4:
                    target = [RunningMonster monster];
                    break;
            }
            break;
    }
    return target;
}

+(NSArray*) generateWave:(int)lvl
{
    int mType = arc4random() % lvl;
    switch (mType) {
        case 0:
            return [self wave1];
        case 1:
            return [self wave2];
        case 2:
            return [self wave3];
        case 3:
            return [self wave4];
        case 4:
            return [self wave5];
        case 5:
            return [self wave6];
        case 6:
            return [self wave7];
        default:
            return [self wave8];
    }
    return nil;
}

+(NSArray*) wave1 {
    return [NSArray arrayWithObjects:[WeakAndFastMonster monster], [WeakAndFastMonster monster], [StrongAndSlowMonster monster], nil];
}

+(NSArray*) wave2 {
    return [NSArray arrayWithObjects:[FiringMonster monster], [FiringMonster monster], [FiringMonster monster], nil];
}

+(NSArray*) wave3 {
    return [NSArray arrayWithObjects:[RunningMonster monster], [RunningMonster monster], [RunningMonster monster], nil];
}

+(NSArray*) wave4 {
    return [NSArray arrayWithObjects:[RunningMonsterStrong monster], [RunningMonsterStrong monster], [RunningMonsterStrong monster], nil];
}

+(NSArray*) wave5 {
    return [NSArray arrayWithObjects:[FiringMonsterStrong monster], [FiringMonsterStrong monster], [FiringMonsterStrong monster], nil];
}

+(NSArray*) wave6 {
    return [NSArray arrayWithObjects:[FollowingMonster monster], [FiringMonsterStrong monster], [FiringMonsterStrong monster], nil];
}

+(NSArray*) wave7 {
    return [NSArray arrayWithObjects:[FollowingMonster monster], [RunningMonsterStrong monster], [RunningMonsterStrong monster], nil];
}

+(NSArray*) wave8 {
    return [NSArray arrayWithObjects:[FollowingMonster monster], [FiringMonsterStrong monster], [RunningMonsterStrong monster], [FollowingMonster monster], [RunningMonsterStrong monster], nil];
}

@end

@implementation WeakAndFastMonster

+ (id)monster {
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m0.png"] autorelease])) {
        monster.hp = monster.hpBase = 1;
        monster.minMoveDuration = 3;
        monster.maxMoveDuration = 5;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = self.contentSize.height/2 + 8 * TILE_SIZE;
    int maxY = winSize.height - self.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(winSize.width + (self.contentSize.width/2), actualY);
    [layer addChild:self];
    
    // Determine speed of the target
    int minDuration = self.minMoveDuration; //2.0;
    int maxDuration = self.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-self.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    [self runAction:[CCSequence actions:delayAction, actionMove, actionMoveDone, nil]];

}

@end

@implementation StrongAndSlowMonster

+ (id)monster {
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m1.png"] autorelease])) {
        monster.hp = monster.hpBase = 4;
        monster.minMoveDuration = 8;
        monster.maxMoveDuration = 12;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = self.contentSize.height/2 + 8 * TILE_SIZE;
    int maxY = winSize.height - self.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(winSize.width + (self.contentSize.width/2), actualY);
    [layer addChild:self];
    
    // Determine speed of the target
    int minDuration = self.minMoveDuration; //2.0;
    int maxDuration = self.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-self.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    [self runAction:[CCSequence actions:delayAction, actionMove, actionMoveDone, nil]];

}

@end

@implementation FiringMonster

+ (id)monster {
    FiringMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m5.png"] autorelease])) {
        monster.hp = monster.hpBase = 1;
        monster.minMoveDuration = 10;
        monster.maxMoveDuration = 10;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    int loopSize = 100;
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = self.contentSize.height/2 + 4 * TILE_SIZE + 2 * loopSize;
    int maxY = winSize.height - self.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    int offset = arc4random() % 75;
    self.position = ccp(winSize.width + (self.contentSize.width/2) + offset, actualY);
    [layer addChild:self];
        
    // Create the actions
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    id actionFire = [CCCallFuncN actionWithTarget:self
                                         selector:@selector(fire)];

    CGPoint tmp = ccpAdd(self.position, ccp(-loopSize, 0));
    CCFiniteTimeAction *action1 = [CCMoveTo actionWithDuration:.6
                                         position:tmp];
    
    ccBezierConfig bezierMove1;
    tmp = ccpAdd(tmp, ccp(-loopSize,-loopSize/2));
    bezierMove1.controlPoint_1 = tmp;
    tmp = ccpAdd(tmp, ccp(0,-loopSize/2));
    bezierMove1.controlPoint_2 = tmp;
    tmp = ccpAdd(tmp, ccp(loopSize/2,0));
    bezierMove1.endPosition = tmp;
    
    ccBezierConfig bezierMove2;
    tmp = ccpAdd(tmp, ccp(loopSize/2,0));
    bezierMove2.controlPoint_1 = tmp;
    tmp = ccpAdd(tmp, ccp(0,loopSize/2));
    bezierMove2.controlPoint_2 = tmp;
    tmp = ccpAdd(tmp, ccp(-loopSize,loopSize/2));
    bezierMove2.endPosition = tmp;

    tmp = ccpAdd(tmp, ccp(-loopSize, 0));
    CCFiniteTimeAction *action2 = [CCMoveTo actionWithDuration:.6
                                                      position:tmp];

    ccBezierConfig bezierMove3;
    tmp = ccpAdd(tmp, ccp(-loopSize,-loopSize/2));
    bezierMove3.controlPoint_1 = tmp;
    tmp = ccpAdd(tmp, ccp(0,-loopSize/2));
    bezierMove3.controlPoint_2 = tmp;
    tmp = ccpAdd(tmp, ccp(loopSize/2,0));
    bezierMove3.endPosition = tmp;
    
    ccBezierConfig bezierMove4;
    tmp = ccpAdd(tmp, ccp(loopSize/2,0));
    bezierMove4.controlPoint_1 = tmp;
    tmp = ccpAdd(tmp, ccp(0,loopSize/2));
    bezierMove4.controlPoint_2 = tmp;
    tmp = ccpAdd(tmp, ccp(-loopSize,loopSize/2));
    bezierMove4.endPosition = tmp;
    
    tmp = ccpAdd(tmp, ccp(-2*loopSize, 0));
    CCFiniteTimeAction *action3 = [CCMoveTo actionWithDuration:1.2
                                   position:tmp];

    [self runAction:[CCSequence actions:delayAction, action1, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove1], actionFire, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove2], action2, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove3], actionFire, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove4], action3, actionMoveDone , nil]];
    mLayer = (GameLevelLayer *)layer;
}

-(void) fire
{
    CCSprite *proj = [MonsterShoot spriteWithFile:@"pixlife_pink.png"];
    int x = self.position.x, y = self.position.y - self.boundingBox.size.height/2;
    proj.position = ccp(x, y);
    CGPoint dest = ccp(x+31, 4 * TILE_SIZE + proj.boundingBox.size.height/2);
    float realMoveDuration = abs(y - dest.y)/250.0;
    proj.tag = 3;
    [proj runAction:[CCSequence actions:
                               [CCMoveTo actionWithDuration:realMoveDuration position:dest],
                               [CCCallFuncN actionWithTarget:mLayer selector:@selector(spriteMoveFinished:)],
                               nil]];
    [mLayer.monsterShoot addObject:proj];
    [mLayer addChild:proj];
}

@end

@implementation RunningMonster

+ (id)monster {
    RunningMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m2.png"] autorelease])) {
        monster.hp = monster.hpBase = 1;
        monster.minMoveDuration = 3;
        monster.maxMoveDuration = 4;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(-self.contentSize.width/2, self.contentSize.height/2 + 16);
    [layer addChild:self];
    
    // Determine speed of the target
    int minDuration = self.minMoveDuration; //2.0;
    int maxDuration = self.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CGPoint p1 = ccp(winSize.width + (self.contentSize.width/2), self.position.y);
    CGPoint p2 = ccp(p1.x, p1.y + 3 * TILE_SIZE);
    CGPoint p3 = ccp(-self.contentSize.width/2, p2.y);
    
    // Create the actions
    id actionMove1 = [CCMoveTo actionWithDuration:actualDuration
                                        position:p1];
    id actionMove2 = [CCMoveTo actionWithDuration:0.1
                                         position:p2];
    id actionMove3 = [CCMoveTo actionWithDuration:actualDuration
                                         position:p3];
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    [self runAction:[CCSequence actions:delayAction, actionMove1, actionMove2, actionMove3, actionMoveDone, nil]];

}

@end

@implementation RunningMonsterStrong

+ (id)monster {
    RunningMonsterStrong *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m3_2.png"] autorelease])) {
        monster.hp = monster.hpBase = 4;
        monster.minMoveDuration = 4;
        monster.maxMoveDuration = 6;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(-self.contentSize.width/2, self.contentSize.height/2 + 16);
    [layer addChild:self];
    
    // Determine speed of the target
    int minDuration = self.minMoveDuration; //2.0;
    int maxDuration = self.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CGPoint p1 = ccp(winSize.width + (self.contentSize.width/2), self.position.y);
    CGPoint p2 = ccp(p1.x, p1.y + 3 * TILE_SIZE);
    CGPoint p3 = ccp(-self.contentSize.width/2, p2.y);
    
    // Create the actions
    id actionMove1 = [CCMoveTo actionWithDuration:actualDuration
                                         position:p1];
    id actionMove2 = [CCMoveTo actionWithDuration:0.1
                                         position:p2];
    id actionMove3 = [CCMoveTo actionWithDuration:actualDuration
                                         position:p3];
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    [self runAction:[CCSequence actions:delayAction, actionMove1, actionMove2, actionMove3, actionMoveDone, nil]];
    
}

@end

@implementation FiringMonsterStrong

+ (id)monster {
    FiringMonsterStrong *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m7.png"] autorelease])) {
        monster.hp = monster.hpBase = 5;
        monster.minMoveDuration = 10;
        monster.maxMoveDuration = 10;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    id delayAction = [CCDelayTime actionWithDuration:delay];

    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int startY = (arc4random() % 60) + winSize.height - 60 - self.contentSize.height/2;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(winSize.width + (self.contentSize.width/2), startY);
    [layer addChild:self];
    
    // Create the actions
    id actionMoveDone = [CCCallFuncN actionWithTarget:layer
                                             selector:@selector(spriteMoveFinished:)];
    id actionFire = [CCCallFuncN actionWithTarget:self
                                         selector:@selector(fire)];
    
    CGPoint tmp = ccp(75, startY);
    CCFiniteTimeAction *action1 = [CCMoveTo actionWithDuration:2.5
                                                      position:tmp];
    tmp = ccp(75, startY-75);
    CCFiniteTimeAction *action2 = [CCMoveTo actionWithDuration:.6
                                                      position:tmp];
    tmp = ccp(winSize.width-75, startY-75);
    CCFiniteTimeAction *action3 = [CCMoveTo actionWithDuration:2.5
                                                      position:tmp];
    tmp = ccp(winSize.width-75, startY-150);
    CCFiniteTimeAction *action4 = [CCMoveTo actionWithDuration:.6
                                                      position:tmp];
    tmp = ccp(-self.contentSize.width/2, startY-150);
    CCFiniteTimeAction *action5 = [CCMoveTo actionWithDuration:2.5
                                                      position:tmp];
        
    [self runAction:[CCSequence actions:delayAction, action1, actionFire, action2, action3, actionFire, action4, action5, actionMoveDone, nil]];
    mLayer = (GameLevelLayer *)layer;
}

-(void) fire
{
    for (int i = 0; i < 2; i++) {
        CCSprite *proj = [MonsterShoot spriteWithFile:@"pixlife_pink.png"];
        int x = self.position.x, y = self.position.y - self.boundingBox.size.height/2;
        proj.position = ccp(x + (1-2*i)*18, y);
        CGPoint dest = ccp(x + (1-2*i)*18, 4 * TILE_SIZE + proj.boundingBox.size.height/2);
        float realMoveDuration = abs(y - dest.y)/285.0;
        proj.tag = 3;
        [proj runAction:[CCSequence actions:
                         [CCMoveTo actionWithDuration:realMoveDuration position:dest],
                         [CCCallFuncN actionWithTarget:mLayer selector:@selector(spriteMoveFinished:)],
                         nil]];
        [mLayer.monsterShoot addObject:proj];
        [mLayer addChild:proj];
    }
}

@end

@implementation FollowingMonster

+ (id)monster {
    FollowingMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m4_2.png"] autorelease])) {
        monster.hp = monster.hpBase = 1;
        monster.minMoveDuration = 8;
        monster.maxMoveDuration = 12;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay {
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = self.contentSize.height/2 + 6 * TILE_SIZE;
    int maxY = winSize.height - self.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.position = ccp(winSize.width + (self.contentSize.width/2), actualY);
    [layer addChild:self];
    
    mLayer = (GameLevelLayer *)layer;
    
    [self schedule:@selector(changeDirection) interval:0.2];
    
}

-(void) changeDirection
{
    CGPoint direction = ccpNormalize(ccpSub(mLayer.player.position, self.position));
        
    // Determine speed of the target
    float time = 0.2;
    float speed = 180.0 + (arc4random() % 70);
    CGPoint destination = ccpAdd(self.position, ccpMult(direction, speed * time));
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:0.2
                                        position:destination];
    [self runAction:[CCSequence actions:actionMove, nil]];
}

@end

