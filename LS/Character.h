//
//  Character.h
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BasicLevelScene.h"

@class Weapon;
@class GameLevelLayer;

@interface Character : CCSprite <wallCollision> {
    GameLevelLayer *gameLayer;
    
    int _lvl;
    int _points;
    int _time;
    int _monsterTot;
    int _monsterKilled;
    int _monsterHitted;
    int _ammoTot;
    int _ammoTaken;
    
    int _hp;
    Weapon *_weapon;
    CCLabelTTF *_hpLabel;
    CCLabelTTF *_pointsLabel;
}

@property (nonatomic, retain) GameLevelLayer *gameLayer;

@property (nonatomic, assign) int lvl;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int monsterTot;
@property (nonatomic, assign) int monsterKilled;
@property (nonatomic, assign) int monsterHitted;
@property (nonatomic, assign) int ammoTot;
@property (nonatomic, assign) int ammoTaken;

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) BOOL onGround;

@property (nonatomic, retain) CCLabelTTF *hpLabel;
@property (nonatomic, retain) CCLabelTTF *pointsLabel;
@property (nonatomic, retain) Weapon *weapon;

-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;
-(void)fireAt:(CGPoint)touch inLayer:(GameLevelLayer *)layer;
-(void)explodeInLayer:(CCLayer *)layer;

@end
