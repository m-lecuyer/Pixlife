//
//  AppDelegate.m
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright Polytechnique 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]]; 

	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
    }
    
    //GADInterstitial *splashInterstitial_ = [[GADInterstitial alloc] init];
    //splashInterstitial_.adUnitID = @"a151859a0d6c329";
    //[splashInterstitial_ loadAndDisplayRequest:[GADRequest request] usingWindow:window_ initialImage:[UIImage imageNamed:@"Default.png"]];
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"a151859a0d6c329";
    interstitial_.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [interstitial_ loadRequest:request];
    adOk = YES;
    
    [self displayAds];
    
	return YES;
}


#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"Received ad successfully");
    if (adOk) {
        [interstitial_ presentFromRootViewController:window_.rootViewController];
    }
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    // Remove the imageView_ once the interstitial is dismissed.
}

#pragma mark - handle ads

- (void) displayAds
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopAds)
                                                 name:@"noads" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startAds)
                                                 name:@"ads" object:nil];

    //CGSize size = [[CCDirector sharedDirector] winSize];

    // iAd
    iAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    iAd.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    iAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;

    CGRect r = iAd.frame;
    //r.origin.x = size.width-r.size.width;
    [iAd setFrame:r];
    iAdIsVisible = NO;
    iAd.frame = CGRectOffset(iAd.frame, 0, -iAd.frame.size.height);
    iAd.delegate = self;
    //iAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [window_.rootViewController.view addSubview:iAd];

    // admob
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    bannerView_.frame = CGRectOffset(bannerView_.frame, 0, -bannerView_.frame.size.height);
    admobIsVisible = NO;
    admobLoaded = NO;
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a151859a0d6c329";
    bannerView_.delegate = self;
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = window_.rootViewController;
    [window_.rootViewController.view addSubview:bannerView_];
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
}

-(void) stopAds
{
    adOk = NO;
    [self hideAd];
}

-(void) startAds
{
    adOk = YES;
    [self showAd];
}

- (void) showAd
{
    if (iAd.isBannerLoaded) {
        [self stateIAdForShow:YES];
        [self stateAdMobForShow:NO];
    } else if (admobLoaded) {
        [self stateIAdForShow:NO];
        [self stateAdMobForShow:YES];
    } else {
        [self stateIAdForShow:NO];
        [self stateAdMobForShow:NO];
    }
}

- (void) hideAd
{
    [self stateIAdForShow:NO];
    [self stateAdMobForShow:NO];
}

- (void) stateIAdForShow:(BOOL)show
{
    if (show && !iAdIsVisible) {
        [UIView beginAnimations:@"animateIAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        iAd.frame = CGRectOffset(iAd.frame, 0, iAd.frame.size.height);
        [UIView commitAnimations];
        iAdIsVisible = YES;
    } else if (!show && iAdIsVisible) {
        [UIView beginAnimations:@"animateIAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        iAd.frame = CGRectOffset(iAd.frame, 0, -iAd.frame.size.height);
        [UIView commitAnimations];
        iAdIsVisible = NO;
    }
}

- (void) stateAdMobForShow:(BOOL)show
{
    if (show && !admobIsVisible) {
        [UIView beginAnimations:@"animateAdMobBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        bannerView_.frame = CGRectOffset(bannerView_.frame, 0, bannerView_.frame.size.height);
        [UIView commitAnimations];
        admobIsVisible = YES;
    } else if (!show && admobIsVisible) {
        [UIView beginAnimations:@"animateAdMobBannerOff" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        bannerView_.frame = CGRectOffset(bannerView_.frame, 0, -bannerView_.frame.size.height);
        [UIView commitAnimations];
        admobIsVisible = NO;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (adOk)
        [self showAd];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (adOk)
        [self showAd];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    admobLoaded = YES;
    if (adOk)
        [self showAd];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    admobLoaded = NO;
    if (adOk)
        [self showAd];
}


// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end

