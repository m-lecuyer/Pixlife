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
    float _accuracy;
    float _collected;
    float _escapted;
    int _time;
    int _lvl;
    int _points;
}

@property (nonatomic, assign) float accuracy;
@property (nonatomic, assign) float collected;
@property (nonatomic, assign) float escapted;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int lvl;
@property (nonatomic, assign) int points;

+(CCScene *) sceneWithAccuracy:(float) accuracy collected:(float)collected escaped:(float)escaped time:(int)time lvl:(int)lvl score:(int)points;

@end



