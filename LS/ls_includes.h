//
//  ls_includes.h
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#define INITIAL_HP 100
#define OFFSET_FOR_PROJECTILES 10
#define PROJECTILE_TAG 2
#define NUMNER_OF_BULLETS_SHOTGUN 8
#define HP_LOST_FOR_MONSTER_HIT 10
#define HP_LOST_FOR_MONSTER_SHOOT 10
#define AMMO_LIFE_TIME 3
#define G 550
#define AMMO_FOR_MONSTER_DEATH 5
#define SPEED_OF_PLAYER 250
#define TILE_SIZE 16

#define POINTS_FOR_AMMO 1
#define POINTS_FOR_MONSTER 10

#define RANDOM_PIXLIFE(filename) {                                                          \
                            int i = (arc4random() % 4);                                     \
                            switch (i) {                                                    \
                            case 0:                                                         \
                                filename = [NSString stringWithFormat:@"pixlife.png"];      \
                                break;                                                      \
                            case 1:                                                         \
                                filename = [NSString stringWithFormat:@"pixlife_blue.png"]; \
                                break;                                                      \
                            case 2:                                                         \
                                filename = [NSString stringWithFormat:@"pixlife_green.png"];\
                                break;                                                      \
                            case 3:                                                         \
                                filename = [NSString stringWithFormat:@"pixlife_yellow.png"];\
                                break;                                                      \
                            }                                                               \
                        }


