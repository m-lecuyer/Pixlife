//
//  Ammunition.h
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "cocos2d.h"
#import "BasicLevelScene.h"
#import "SpaceManagerCocos2d.h"

@interface Ammunition : cpCCSprite {
    float _lifeTime;
    CCLayer *_gameLayer;
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) float lifeTime;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spaceManager gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName;
+(id)initRandomWithSpaceManager:(SpaceManagerCocos2d *)spaceManager gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location;
-(CGRect)collisionBoundingBox;
-(void) remove;

@end
