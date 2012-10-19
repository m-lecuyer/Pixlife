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

@synthesize accuracy;
@synthesize collected;
@synthesize escapted;

+(CCScene *) sceneWithAccuracy:(float) accuracy collected:(float)collected escaped:(float)escaped
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameResult *layer = [GameResult node];
    layer.accuracy = accuracy;
    layer.collected = collected;
    layer.escapted = escaped;
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        //window size
        CGSize size = [[CCDirector sharedDirector] winSize];
						
        // Default font size will be 28 points.
        [CCMenuItemFont setFontSize:28];
		// Achievement Menu Item using blocks
		CCMenuItem *itemMenu = [CCMenuItemFont itemWithString:@"Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[HelloWorldLayer scene]]];
		}
                                    ];
        
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemReplay = [CCMenuItemFont itemWithString:@"Replay!" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLevelLayer scene]]];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemMenu, itemReplay, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}

@end
