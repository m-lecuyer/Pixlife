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

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, ADBannerViewDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_; // weak ref
    
    ADBannerView *iAd;
    BOOL adOk;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property () BOOL bannerIsVisible;

@end
