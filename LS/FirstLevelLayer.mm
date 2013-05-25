//
//  FirstLevelLayer.m
//  LS
//
//  Created by Mathias on 5/25/13.
//  Copyright (c) 2013 Polytechnique. All rights reserved.
//

#import "FirstLevelLayer.h"
#import "Box2D.h"
#import "ls_includes.h"

@interface FirstLevelLayer()
{
    b2World *_world;
    
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
}

@end

@implementation FirstLevelLayer

static GameLevelLayer *layer;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	layer = [FirstLevelLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noads" object:self];
    
	// return the scene
	return scene;
}

- (void) createGround
{
    NSLog(@"EXTENDED GROUND");
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    b2Body *_groundBody = _world->CreateBody(&groundBodyDef);
    
    b2EdgeShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    
    groundBox.Set(b2Vec2(0,200/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 200/PTM_RATIO));
    groundBoxDef.filter.categoryBits = CATEGORY_GROUND;
    groundBoxDef.filter.maskBits = MASK_GROUND;
    _groundBody->CreateFixture(&groundBoxDef);
}

@end
