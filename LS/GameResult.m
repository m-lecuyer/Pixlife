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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ads" object:self];

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
    //left
    CGSize size = [[CCDirector sharedDirector] winSize];
    float wR = size.width/2-150;
    CCLabelTTF *acc = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Accuracy: %i%%", (int)(100*layer.accuracy)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    acc.position = ccp(wR, 260);
    [layer addChild:acc];
    
    CCLabelTTF *col = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Ammo collected: %i%%", (int)(100*layer.collected)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    col.position = ccp(wR, 220);
    [layer addChild:col];
    
    CCLabelTTF *esc = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Monster killed: %i%%", (int)(100*layer.escapted)] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    esc.position = ccp(wR, 180);
    [layer addChild:esc];
    
    CCLabelTTF *t = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Survieved: %is", layer.time] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    t.position = ccp(wR, 140);
    [layer addChild:t];
    
    CCLabelTTF *lv = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Level: %i", layer.lvl] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentRight fontName:@"Helvetica" fontSize:20];
    lv.position = ccp(wR, 100);
    [layer addChild:lv];

    //right
    int bonusP = (int)(100*layer.accuracy)+(int)(100*layer.collected)+(int)(100*layer.escapted)+MIN(layer.time/10,100)+layer.lvl*10;
    if (!bonusP) {
        bonusP = 0;
    }
    CCLabelTTF *bonus = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Bonus: %i", bonusP] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:20];
    bonus.position = ccp(size.width-wR, 200);
    [layer addChild:bonus];
    
    int tot = layer.points+bonusP;
    CCLabelTTF *total = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Total points: %i", tot] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:24];
    total.position = ccp(size.width-wR, 160);
    [layer addChild:total];

    if (tot > [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:tot forKey:@"bestScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CCLabelTTF *newBest = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"New best score!"] dimensions:CGSizeMake(250, 30) hAlignment:UITextAlignmentLeft fontName:@"Helvetica-Oblique" fontSize:12];
        newBest.position = ccp(size.width-wR, 135);
        [layer addChild:newBest];
    }
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        //window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *img = [[CCSprite alloc] initWithFile:@"Heart.png"];
        //player.scale = 2.0;
        //[player.texture setAliasTexParameters];
        img.position = ccp(size.width/2, size.height/2);
        img.opacity = 60;
        [self addChild:img z:-1];
        
        // Menue
        [CCMenuItemFont setFontSize:30];
		// Achievement Menu Item using blocks
		CCMenuItem *itemMenu = [CCMenuItemFont itemWithString:@"Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[HelloWorldLayer scene]]];
		}];
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemReplay = [CCMenuItemFont itemWithString:@"Replay!" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLevelLayer scene]]];
		}];
		CCMenu *menu = [CCMenu menuWithItems:itemMenu, itemReplay, nil];
		[menu alignItemsHorizontallyWithPadding:200];
		[menu setPosition:ccp(size.width/2, 40)];
		[self addChild:menu];
	}
	return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
