//
//  GameResult.h
//  LS
//
//  Created by MatLecu on 03/10/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface GameResult : CCLayer
{
    float accuracy;
    float collected;
    float escapted;

}

@property (nonatomic, assign) float accuracy;
@property (nonatomic, assign) float collected;
@property (nonatomic, assign) float escapted;

+(CCScene *) sceneWithAccuracy:(float) accuracy collected:(float)collected escaped:(float)escaped;

@end



