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

@implementation Ammunition

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize lifeTime = _lifeTime;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spaceManager gameLayer:(CCLayer*)gameLayer location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithFile:spriteFrameName]) {
        self.shape = [spaceManager addRectAt:location mass:0.01 width:self.contentSize.width height:self.contentSize.height rotation:0];
        self.shape->data = self;
        self.shape->collision_type = [self class];
        self.shape->e = 0.0f;
        cpBodySetMoment(self.body, INFINITY);
        self.spaceManager = spaceManager;
        _lifeTime = 0;
        _onGround = NO;
        _gameLayer = gameLayer;
        
        id d = [CCDelayTime actionWithDuration:AMMO_LIFE_TIME];
		id c = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
        [self runAction:[CCSequence actions:d,c,nil]];
    }
    return self;
}

+(id)initRandomWithSpaceManager:(SpaceManagerCocos2d *)spaceManager gameLayer:(CCLayer*)gmaeLAyer location:(CGPoint)location
{
    Ammunition *b = [Ammunition alloc];
    //NSString *filename = [NSString stringWithFormat:@"pixlife.png"];
    NSString *filename;
    RANDOM_PIXLIFE(filename);
    if ((b = [b initWithSpaceManager:spaceManager gameLayer:gmaeLAyer location:location spriteFrameName:filename])) {
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
    [self.spaceManager removeAndFreeShape:self.shape];
    [((GameLevelLayer *)_gameLayer).ammunitions removeObject:self];
}

@end
