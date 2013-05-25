//
//  Monster.h
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@class GameLevelLayer;

@interface Monster : CCSprite {
    int _hpBase;
    int _curHp;
    float _minMoveDuration;
    float _maxMoveDuration;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int hpBase;
@property (nonatomic, assign) float minMoveDuration;
@property (nonatomic, assign) float maxMoveDuration;

-(void) youRDeadInLayer:(GameLevelLayer *)layer withManager:(b2World *)world;
-(void) positionAndMoveInLayer:(CCLayer *)layer withDelay:(float)delay;

+(Monster*) generateMonsterForLevel:(int)lvl;
+(NSArray*) generateWave:(int)lvl;

+(NSArray*) wave1;
+(NSArray*) wave2;
+(NSArray*) wave3;
+(NSArray*) wave4;
+(NSArray*) wave5;
+(NSArray*) wave6;
+(NSArray*) wave7;
+(NSArray*) wave8;

@end

@interface WeakAndFastMonster : Monster {
}
+(id)monster;
@end

@interface StrongAndSlowMonster : Monster {
}
+(id)monster;
@end

@interface FiringMonster : Monster {
    GameLevelLayer *mLayer;
}
+(id)monster;
@end

@interface RunningMonster : Monster {
}
+(id)monster;
@end

@interface RunningMonsterStrong : Monster {
}
+(id)monster;
@end

@interface FiringMonsterStrong : Monster {
    GameLevelLayer *mLayer;
}
+(id)monster;
@end

@interface FollowingMonster : Monster {
     GameLevelLayer *mLayer;
}
+(id)monster;
@end