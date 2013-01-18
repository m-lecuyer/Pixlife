//
//  GameResult.m
//  LS
//
//  Created by MatLecu on 03/10/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "GameResult.h"
#import "HelloWorldLayer.h"
#import "BasicLevelScene.h"

@implementation GameResult

@synthesize accuracy = _accuracy , collected = _collected , escapted = _escapted, time = _time , lvl = _lvl , points = _points;

+(CCScene *) sceneWithAccuracy:(float) accuracy collected:(float)collected escaped:(float)escaped time:(int)time lvl:(int)lvl score:(int)points
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameResult *layer = [GameResult node];
    layer.accuracy = accuracy;
    layer.collected = collected;
    layer.escapted = escaped;
    layer.time = time;
    layer.lvl = lvl;
    layer.points = points;
	// add layer as a child to scene
	[scene addChild: layer];
    // stats
    CGSize size = [[CCDirector sharedDirector] winSize];
     CCLabelTTF *acc = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Accuracy: %i%%", (int)(100*layer.accuracy)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    acc.position = ccp(size.width/3, 270);
    [layer addChild:acc];
    
    CCLabelTTF *col = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Ammo collected: %i%%", (int)(100*layer.collected)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    col.position = ccp(size.width/3, 230);
    [layer addChild:col];
    
    CCLabelTTF *esc = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Monster escaped: %i%%", (int)(100*layer.escapted)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    esc.position = ccp(size.width/3, 190);
    [layer addChild:esc];
    
    CCLabelTTF *t = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Survieved: %is", layer.time] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    t.position = ccp(size.width/3, 150);
    [layer addChild:t];
    
    CCLabelTTF *lv = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Level: %i", layer.lvl] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    lv.position = ccp(size.width/3, 110);
    [layer addChild:lv];

	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        //window size
        CGSize size = [[CCDirector sharedDirector] winSize];
						
        // Menue
        [CCMenuItemFont setFontSize:28];
		// Achievement Menu Item using blocks
		CCMenuItem *itemMenu = [CCMenuItemFont itemWithString:@"Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[HelloWorldLayer scene]]];
		}];
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemReplay = [CCMenuItemFont itemWithString:@"Replay!" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLevelLayer scene]]];
		}];
		CCMenu *menu = [CCMenu menuWithItems:itemMenu, itemReplay, nil];
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp(size.width/2, size.height/2 - 100)];
		[self addChild:menu];
	}
	return self;
}

@end
