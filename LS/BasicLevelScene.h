//
//  BasicLevelScene.h
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

@protocol wallCollision <NSObject>

@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;

-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;

@end

@class Character;

@interface GameLevelLayer : CCLayer {
    Character *player;
    SpaceManagerCocos2d *_smgr;
}

@property (getter = isInPause) BOOL pause;
@property (nonatomic, retain) Character *player;
@property (nonatomic, retain) NSMutableArray *projectiles;
@property (nonatomic, retain) NSMutableArray *ammunitions;
@property (nonatomic, retain) NSMutableArray *monsterShoot;

+(CCScene *) scene;
-(void)gameOver;

@end
