//
//  ls_includes.h
//  LS
//
//  Created by MatLecu on 17/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

// ratio points to meters for physical simulation
#define PTM_RATIO 32.0
// categories for Box2d bodies
#define CATEGORY_GROUND 0x0001
#define CATEGORY_PLAYER 0x0002
#define CATEGORY_AMMO 0x0004
// collison masks for box2D
#define MASK_GROUND -1 // collide with everything
#define MASK_PLAYER CATEGORY_GROUND | CATEGORY_AMMO
#define MASK_AMMO CATEGORY_GROUND | CATEGORY_PLAYER

#define INITIAL_HP 100
#define OFFSET_FOR_PROJECTILES 10
#define PROJECTILE_TAG 2
#define NUMNER_OF_BULLETS_SHOTGUN 8
#define HP_LOST_FOR_MONSTER_HIT 10
#define HP_LOST_FOR_MONSTER_SHOOT 10
#define AMMO_LIFE_TIME 4
#define G 550
#define AMMO_FOR_MONSTER_DEATH 5
#define SPEED_OF_PLAYER 250
#define TILE_SIZE 16

#define POINTS_FOR_AMMO 1
#define POINTS_FOR_MONSTER 1

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


