//
//  Character.m
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "Character.h"
#import "BasicLevelScene.h"
#import "Weapon.h"
#import "Shotgun.h"
#import "ls_includes.h"
#import "SimpleAudioEngine.h"
#import "Box2D.h"

@interface Character () {
    b2World *_world;
    b2Fixture *_characterFixture;
}

@end

@implementation Character

@synthesize gameLayer;

@synthesize lvl = _lvl;
@synthesize time = _time;
@synthesize monsterTot = _monsterTot;
@synthesize monsterKilled = _monsterKilled;
@synthesize monsterHitted = _monsterHitted;
@synthesize ammoTot = _ammoTot;
@synthesize ammoTaken = _ammoTaken, ammoShot = _ammoShot, ammoHit = _ammoHit;

@synthesize velocity = _velocity;
@synthesize desiredPosition = _desiredPosition;
@synthesize onGround = _onGround;
@synthesize weapon = _weapon;
@synthesize hp = _hp;
@synthesize points = _points;
@synthesize hpLabel = _hpLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize lvlLabel = _lvlLabel;


- (id)initWithSpaceManager:(b2World *)world gameLayer:(GameLevelLayer*)gameLAyer location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName
{
    if ((self = [super initWithFile:spriteFrameName])) {
        _world = world;
        self.gameLayer = gameLAyer;
        self.tag = 1;
        
        b2BodyDef characterBodyDef;
        characterBodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
        characterBodyDef.type = b2_dynamicBody;
        characterBodyDef.fixedRotation = true;
        characterBodyDef.userData = self;
        
        _characterBody = _world->CreateBody(&characterBodyDef);
        b2PolygonShape characterShape;
        characterShape.SetAsBox(self.contentSize.width/PTM_RATIO/2, self.contentSize.height/PTM_RATIO/2);
        b2FixtureDef characterShapeDef;
        characterShapeDef.shape = &characterShape;
        characterShapeDef.density = 10.0f;
        characterShapeDef.friction = 0.4f;
        characterShapeDef.restitution = 0.2f;
        characterShapeDef.filter.categoryBits = CATEGORY_PLAYER;
        characterShapeDef.filter.maskBits = MASK_PLAYER;
        _characterFixture = _characterBody->CreateFixture(&characterShapeDef);

        _time = _monsterTot = _monsterTot = _monsterKilled = _ammoTot = _ammoTaken = 0;
        _lvl = 1;
        _points = 0;
        _hp = INITIAL_HP;
        self.weapon = [Shotgun weapon];
        self.velocity = ccp(0.0, 0.0);        
    }
    return self;
}

-(void)setHp:(int)hp {
    if (_hp == 0)
        return;
    
    if (_hp > hp && [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"])
        [[SimpleAudioEngine sharedEngine] playEffect:@"hurt.wav"];
    _hp = max(hp, 0);
    [self.hpLabel setString:[NSString stringWithFormat:@"%i", _hp]];
    if (_hp == 0) {
        [gameLayer scheduleOnce:@selector(gameOver) delay:.8];
    }
}

-(void)setLvl:(int)lvl {
    if (_hp == 0)
        return;
    _lvl = lvl;
    [self.lvlLabel setString:[NSString stringWithFormat:@"lvl %i", _lvl]];
}

-(void)setPoints:(int)points {
    if (_hp == 0)
        return;

    _points = points;
    [self.pointsLabel setString:[NSString stringWithFormat:@"%i", _points]];
}

-(void)setAmmoTaken:(int)ammoTaken {
    if (_hp == 0)
        return;

    _ammoTaken = ammoTaken;
    //self.points += POINTS_FOR_AMMO;
}

-(void)setMonsterKilled:(int)monsterKilled {
    if (_hp == 0)
        return;

    _monsterKilled = monsterKilled;
    self.points += POINTS_FOR_MONSTER * _lvl;
}

-(void) setMonsterTot:(int)monsterTot {
    if (_hp == 0)
        return;

    _monsterTot = monsterTot;
}

-(void)setVelocity:(CGPoint)velocity {
    if (_hp == 0)
        return;
    _velocity = velocity;
    if (velocity.x < 0) {
        self.scaleX = - abs(self.scaleX);
    } else {
        self.scaleX = abs(self.scaleX);
    }
}

-(void)update:(ccTime)dt 
{
    if (_hp == 0)
        return;

    CGPoint gravity = ccp(0.0, -550.0);
    
    CGPoint gravityStep = ccpMult(gravity, dt);
    
    self.velocity = ccpAdd(self.velocity, gravityStep);
    CGPoint stepVelocity = ccpMult(self.velocity, dt);
    
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
}

-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 0, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    return returnBoundingBox;
}

-(void)jump
{
    if (_hp == 0 || [gameLayer isInPause])
        return;

    if (self.onGround) {
        b2Vec2 force = b2Vec2(0, 50.0f);
        _characterBody->ApplyLinearImpulse(force, _characterBody->GetPosition());
        self.onGround = NO;
    }
}

-(void)fireAt:(CGPoint)touch inLayer:(GameLevelLayer *)layer
{
    if (_hp == 0)
        return;

    self.hp = self.hp - [self.weapon fireCost];
    NSArray *bullets = [self.weapon fireAt:touch from:self.position inLayer:layer];
    for (CCSprite *b in bullets) {
        [layer addChild:b];
        [layer.projectiles addObject:b];
    }
    self.ammoShot += [bullets count];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"864.mp3"];
    }
}

-(void)explodeInLayer:(CCLayer *)layer
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //compute start and arrive location
    CGPoint startLocation = self.position;
    CGPoint destLocation;
    CGPoint mainDirection = ccpNormalize(ccp(0,1));
    float velocity;
    int rangeV = 100;
    int minSpeed = 50;
    
    NSMutableArray *bullets = [NSMutableArray array];
    for (int i = 0; i < 14; i++) {
        float thetaOffset = i*(2*3.1415)/14;
        velocity = (arc4random() % rangeV) + minSpeed;
        CGPoint direction;
        direction.x = cos(thetaOffset) * mainDirection.x - sin(thetaOffset) * mainDirection.y;
        direction.y = sin(thetaOffset) * mainDirection.x + cos(thetaOffset) * mainDirection.y;
        float ratioX = 0, ratioY = 0;
        if (direction.x > 0)
            ratioX = (winSize.width + OFFSET_FOR_PROJECTILES - startLocation.x) / direction.x;
        else if (direction.x < 0)
            ratioX = (- startLocation.x - OFFSET_FOR_PROJECTILES) / direction.x;
        if (direction.y > 0)
            ratioY = (winSize.height + OFFSET_FOR_PROJECTILES - startLocation.y) / direction.y;
        else if (direction.y < 0)
            ratioY = (- startLocation.y - OFFSET_FOR_PROJECTILES) / direction.y;
        
        float ratio;
        if (ratioX == 0)
            ratio = ratioY;
        else if (ratioY == 0)
            ratio = ratioX;
        else
            ratio = min(ratioX, ratioY);
        
        destLocation = ccpAdd(startLocation, ccpMult(direction, ratio));
        
        float length = ccpDistance(startLocation, destLocation);
        float realMoveDuration = length/velocity;
        
        CCSprite *nextProjectile = [CCSprite spriteWithFile:@"pixlife_white.png"];
        nextProjectile.position = startLocation;
        [nextProjectile runAction:[CCSequence actions:
                                   [CCMoveTo actionWithDuration:realMoveDuration position:destLocation],
                                   [CCCallFuncN actionWithTarget:layer selector:@selector(spriteMoveFinished:)],
                                   nil]];
        [bullets addObject:nextProjectile];
    }
    for (CCSprite *b in bullets) {
        [layer addChild:b];
    }
}

@end
