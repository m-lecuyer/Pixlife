//
//  Ammunition.m
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Ammunition.h"
#import "ls_includes.h"
#import "ls_includes.h"

@implementation Ammunition

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize lifeTime = _lifeTime;

+(id)initRandom
{
    Ammunition *b = [Ammunition alloc];
    //NSString *filename = [NSString stringWithFormat:@"pixlife.png"];
    NSString *filename;
    RANDOM_PIXLIFE(filename);
    if ((b = [b initWithFile:filename])) {
        b.lifeTime = 0;
        b.onGround = NO;
    }
    return b;
}

-(id)initWithFile:(NSString *)filename
{
    if (self = [super initWithFile:filename]) {
        _lifeTime = 0;
        _onGround = NO;
    }
    return self;
}

-(void)update:(ccTime)dt
{
    _lifeTime += dt;
    //TODO remove when out of the window
    
    CGPoint gravity = ccp(0.0, -G);
    CGPoint gravityStep = ccpMult(gravity, dt);
    self.velocity = ccpAdd(self.velocity, gravityStep);
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
    if (_onGround)
        self.velocity = ccp(0, 0);
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}



@end
