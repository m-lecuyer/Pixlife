//
//  HelloWorldLayer.m
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright Polytechnique 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "BasicLevelScene.h"
#import "MusicManager.h"

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer () {
}

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        //window size
        CGSize size = [[CCDirector sharedDirector] winSize];
		// Default font size will be 55 points.
		[CCMenuItemFont setFontSize:55];
        [CCMenuItemFont setFontName:@"Helvetica"];
		// Play Game Menu Item
		CCMenuItem *itemPlayGame = [CCMenuItemFont itemWithString:@"Play Pixlife" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLevelLayer scene]]];
		}];
		CCMenu *playMenu = [CCMenu menuWithItems:itemPlayGame, nil];
		[playMenu alignItemsHorizontallyWithPadding:20];
		[playMenu setPosition:ccp( size.width/2, size.height/2 + 0)];
		// Add the play menu to the layer
		[self addChild:playMenu];
		
        // sound button
        NSString *imageName = @"SoundOn.png";
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
            imageName = @"SoundOff.png";
        }
        CCMenuItemImage *itemSound = [CCMenuItemImage itemWithNormalImage:imageName selectedImage:imageName block:^(id sender) {
            [[MusicManager sharedManager] changeSound];
            NSString *imageName = @"SoundOn.png";
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
                imageName = @"SoundOff.png";
            }
            [sender setNormalImage:[CCSprite spriteWithFile:imageName]];
		}];
        [itemSound setScale:.2];
        playMenu = [CCMenu menuWithItems:itemSound, nil];
		[playMenu alignItemsHorizontallyWithPadding:20];
		[playMenu setPosition:ccp(20, size.height - 20)];
		[self addChild:playMenu];
		        
        [[MusicManager sharedManager] startBackgroundMusic];
	}
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
