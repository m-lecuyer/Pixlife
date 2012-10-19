//
//  Weapon.h
//  LS
//
//  Created by MatLecu on 16/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "cocos2d.h"

@interface Weapon : CCSprite {
}

-(int)fireCost;
-(NSArray *)fireAt:(CGPoint)touch from:(CGPoint)startLocation inLayer:(CCLayer *)layer;

+(id)weapon;

@end