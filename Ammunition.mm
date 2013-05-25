//
//  Ammunition.m
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Ammunition.h"
#import "ls_includes.h"
#import "BasicLevelScene.h"

@interface Ammunition () {
    b2World *_world;
    b2Fixture *_ammoFixture;
}

@end

@implementation Ammunition

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize lifeTime = _lifeTime;
@synthesize ammoBody = _ammoBody;

- (id)initWithSpaceManager:(b2World *)world gameLayer:(CCLayer*)gameLayer location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithFile:spriteFrameName]) {
        _world = world;
        _gameLayer = gameLayer;
        self.tag = 2;
        b2BodyDef ammoBodyDef;
        ammoBodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        ammoBodyDef.type = b2_dynamicBody;
        ammoBodyDef.userData = self;
        
        _ammoBody = _world->CreateBody(&ammoBodyDef);
        b2PolygonShape ammoShape;
        ammoShape.SetAsBox(self.contentSize.width/PTM_RATIO/2, self.contentSize.height/PTM_RATIO/2);
        b2FixtureDef ammoShapeDef;
        ammoShapeDef.shape = &ammoShape;
        ammoShapeDef.density = 0.1f;
        ammoShapeDef.friction = 10.0f;
        ammoShapeDef.restitution = 0.1f;
        ammoShapeDef.filter.categoryBits = CATEGORY_AMMO;
        ammoShapeDef.filter.maskBits = MASK_AMMO;
        _ammoFixture = _ammoBody->CreateFixture(&ammoShapeDef);
        
        //self.shape = [spaceManager addRectAt:location mass:0.01 width:self.contentSize.width height:self.contentSize.height rotation:0];        
        id d = [CCDelayTime actionWithDuration:AMMO_LIFE_TIME];
		id c = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
        [self runAction:[CCSequence actions:d,c,nil]];
    }
    return self;
}

+(id)initRandomWithSpaceManager:(b2World *)world gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location
{
    Ammunition *b = [Ammunition alloc];
    //NSString *filename = [NSString stringWithFormat:@"pixlife.png"];
    NSString *filename;
    RANDOM_PIXLIFE(filename);
    if ((b = [b initWithSpaceManager:world gameLayer:gmaeLAyer location:location spriteFrameName:filename])) {
        b.lifeTime = 0;
        b.onGround = NO;
    }
    return b;
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}

-(void) remove {
    [_gameLayer removeChild:self cleanup:YES];
    [((GameLevelLayer *)_gameLayer).ammunitions removeObject:self];
    _world->DestroyBody(_ammoBody);
}

@end
