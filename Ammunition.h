//
//  Ammunition.h
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "cocos2d.h"
#import "BasicLevelScene.h"
#import "Box2D.h"

@interface Ammunition : CCSprite {
    float _lifeTime;
    CCLayer *_gameLayer;
    b2Body *_ammoBody;
}

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) float lifeTime;
@property (readonly) b2Body *ammoBody;


- (id)initWithSpaceManager:(b2World *)world gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName;
+(id)initRandomWithSpaceManager:(b2World *)world gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location;
-(CGRect)collisionBoundingBox;
-(void) remove;

@end
