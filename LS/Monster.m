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
    layer.player.ammoTot += AMMO_FOR_MONSTER_DEATH;
    [layer removeChild:self cleanup:YES];
}

-(void) positionAndMoveInLayer:(CCLayer *)layer {
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

-(void) positionAndMoveInLayer:(CCLayer *)layer {
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
    [self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];

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

-(void) positionAndMoveInLayer:(CCLayer *)layer {
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
    [self runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];

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

-(void) positionAndMoveInLayer:(CCLayer *)layer
{
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

    [self runAction:[CCSequence actions:action1, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove1], actionFire, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove2], action2, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove3], actionFire, [CCBezierTo actionWithDuration:1.5 bezier:bezierMove4], action3, actionMoveDone , nil]];
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

-(void) positionAndMoveInLayer:(CCLayer *)layer {
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
    [self runAction:[CCSequence actions:actionMove1, actionMove2, actionMove3, actionMoveDone, nil]];

}

@end

@implementation RunningMonsterStrong

+ (id)monster {
    RunningMonsterStrong *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"m3_2.png"] autorelease])) {
        monster.hp = monster.hpBase = 4;
        monster.minMoveDuration = 4;
        monster.maxMoveDuration = 5;
    }
    return monster;
}

-(void) positionAndMoveInLayer:(CCLayer *)layer {
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
    [self runAction:[CCSequence actions:actionMove1, actionMove2, actionMove3, actionMoveDone, nil]];
    
}

@end
