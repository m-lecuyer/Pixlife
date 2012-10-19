//
//  Ammunition.h
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "cocos2d.h"
#import "BasicLevelScene.h"

@interface Ammunition : CCSprite <wallCollision> {
    float _lifeTime;
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) float lifeTime;

+(id)initRandom;
-(void)update:(ccTime)dt;
-(CGRect)collisionBoundingBox;

@end
