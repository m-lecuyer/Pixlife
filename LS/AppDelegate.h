//
//  AppDelegate.h
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright Polytechnique 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, ADBannerViewDelegate, GADBannerViewDelegate, GADInterstitialDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_; // weak ref
    
    ADBannerView *iAd;
    BOOL adOk;
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    BOOL iAdIsVisible;
    BOOL admobIsVisible;
    BOOL admobLoaded;
    BOOL hideStatusBar_;
    UIImageView *imageView_;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
