//
//  Shotgun.h
//  LS
//
//  Created by MatLecu on 16/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "CCSprite.h"
#import "Weapon.h"

@interface Shotgun : Weapon {
    int _maxSpeed;
    int _minSpeed;
}

@property (nonatomic, assign) int maxSpeed;
@property (nonatomic, assign) int minSpeed;

@end
