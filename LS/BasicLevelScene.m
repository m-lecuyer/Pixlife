//
//  BasicLevelScene.m
//  LS
//
//  Created by Mathias Lécuyer on 01/09/12.
//  Copyright (c) 2012 Polytechnique. All rights reserved.
//

#import "BasicLevelScene.h"
#import "Character.h"
#import "Monster.h"
#import "ls_includes.h"
#import "Ammunition.h"
#import "GameResult.h"
#import "MusicManager.h"

@interface GameLevelLayer() 
{
    CCTMXTiledMap *map;
    CCTMXLayer *walls;
    NSMutableArray *_monsters;
    NSMutableArray *_projectiles;
    NSMutableArray *_ammunitions;
    NSMutableArray *_monsterShoot;
    CCSprite *_nextProjectile;
    
    int _prevWavN;
}

@end

@implementation GameLevelLayer

@synthesize projectiles = _projectiles;
@synthesize ammunitions = _ammunitions;
@synthesize monsterShoot = _monsterShoot;
@synthesize pause = _pause;

@synthesize player;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noads" object:self];
    
	// return the scene
	return scene;
}

-(id) init
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noads" object:self];

	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self = [super init]) ) {
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        _ammunitions = [[NSMutableArray alloc] init];
        _monsterShoot = [[NSMutableArray alloc] init];

        //window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // map
        if (size.width > 480.0f || size.height > 480.0f) {
            map = [[CCTMXTiledMap alloc] initWithTMXFile:@"basic_level5.tmx"];
        } else {
            map = [[CCTMXTiledMap alloc] initWithTMXFile:@"basic_level.tmx"];
        }

        [self addChild:map];
        walls = [map layerNamed:@"walls"];
        
        // player
        player = [[Character alloc] initWithFile:@"astronaute.png"];
        player.gameLayer = self;
        //player.scale = 2.0;
        //[player.texture setAliasTexParameters];
        player.position = ccp(size.width/2, 150);
        [map addChild:player z:15];
        
        // Jump buttons
        CCMenuItem *buttonJumpLeft = [CCMenuItemImage itemWithNormalImage:@"jump_up.png" selectedImage:@"jump_down.png" target:player selector:@selector(jump)];
        CCMenuItem *buttonJumpRight = [CCMenuItemImage itemWithNormalImage:@"jump_up.png" selectedImage:@"jump_down.png" target:player selector:@selector(jump)];
        CCMenu *jumpMenu = [CCMenu menuWithItems:buttonJumpLeft, buttonJumpRight, nil];
		[jumpMenu alignItemsHorizontallyWithPadding:size.width-2.5*buttonJumpLeft.boundingBox.size.width];
		[jumpMenu setPosition:ccp(size.width/2, buttonJumpLeft.boundingBox.size.height/2)];
        [self addChild:jumpMenu z:100];
        
        // game info labels
        player.hpLabel = [[CCLabelTTF alloc] initWithString:[[NSNumber numberWithInt:player.hp] stringValue] fontName:@"Helvetica" fontSize:20];
        player.hpLabel.position = ccp(size.width/2-80, size.height - 22);
        [self addChild:player.hpLabel];
        CCSprite *lifeImg = [[CCSprite alloc] initWithFile:@"life.png"];
        lifeImg.position = ccp(size.width/2-110, size.height - 22);
        [self addChild:lifeImg];

        player.pointsLabel = [[CCLabelTTF alloc] initWithString:[[NSNumber numberWithInt:player.points] stringValue] fontName:@"Helvetica" fontSize:20];
        player.pointsLabel.position = ccp(size.width/2, size.height - 22);
        player.pointsLabel.fontSize = 22;
        player.pointsLabel.fontName = @"Helvetica-Bold";
        player.pointsLabel.horizontalAlignment = kCCTextAlignmentCenter;
        [self addChild:player.pointsLabel];
        
        player.lvlLabel = [[CCLabelTTF alloc] initWithString:[[NSNumber numberWithInt:player.lvl] stringValue] fontName:@"Helvetica" fontSize:20];
        player.lvlLabel.position = ccp(size.width/2 + 80, size.height - 22);
        [player.lvlLabel setString:[NSString stringWithFormat:@"lvl 1"]];
        [self addChild:player.lvlLabel];
        
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
        CCMenu *playMenu = [CCMenu menuWithItems:itemSound, nil];
		[playMenu alignItemsHorizontallyWithPadding:20];
		[playMenu setPosition:ccp(20, size.height - 20)];
		[self addChild:playMenu];

        // pause button
        NSString *imageNamePause = @"button_grey_pause.png";
        /*if (![[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
            imageName = @"button_grey_pause.png";
        }*/
        CCMenuItemImage *itemPause = [CCMenuItemImage itemWithNormalImage:imageNamePause selectedImage:imageNamePause block:^(id sender) {
            [self pauseGame];
            /*NSString *imageName = @"SoundOn.png";
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]) {
                imageName = @"SoundOff.png";
            }
            [sender setNormalImage:[CCSprite spriteWithFile:imageName]];*/
		}];
        [itemPause setScale:.5];
        CCMenu *pauseMenu = [CCMenu menuWithItems:itemPause, nil];
		[pauseMenu alignItemsHorizontallyWithPadding:20];
		[pauseMenu setPosition:ccp(size.width - 20, size.height - 20)];
		[self addChild:pauseMenu];

        _prevWavN = 0;

        //[self schedule:@selector(update:)];
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self scheduleUpdateWithPriority:-1];
	}
	return self;
}

- (void) pauseGame
{
    if (!_pause) {
        [[CCDirector sharedDirector] pause];
        _pause = YES;
    } else {
        [[CCDirector sharedDirector] resume];
        _pause = NO;
    }
}

-(void)update:(ccTime)dt
{
    [player update:dt];
    NSMutableArray *ammoToRemove = [NSMutableArray array];
    for (Ammunition *a in _ammunitions) {
        [a update:dt];
        if (a.lifeTime > AMMO_LIFE_TIME || !CGRectIntersectsRect(a.boundingBox, self.boundingBox)) {
            [ammoToRemove addObject:a];
        }
        [self checkForAndResolveCollisions:a withBox:false];
    }
    for (Ammunition *a in ammoToRemove) {
        [self removeChild:a cleanup:YES];
        [_ammunitions removeObject:a];
    }
    
    for (CCSprite *b in [self bulletWallsCollisions:self.projectiles]) {
        [self removeChild:b cleanup:YES];
        [_projectiles removeObject:b];
    }

    [self checkForAndResolveCollisions:player withBox:true];
    [self bulletMonsterCollision];
    [self playerMonterCollision];
    [self playerAmmoCollision];
    [self playerMonsterAmmoCollision];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position 
{
    float x = floor(position.x / TILE_SIZE);
    float levelHeightInPixels = map.mapSize.height * TILE_SIZE;
    float y = floor((float)(levelHeightInPixels - position.y) / TILE_SIZE);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords 
{
    float levelHeightInPixels = map.mapSize.height * TILE_SIZE;
    CGPoint origin = ccp(tileCoords.x * TILE_SIZE, levelHeightInPixels - ((tileCoords.y + 1) * TILE_SIZE));
    CGPoint dimensions = ccp(TILE_SIZE, TILE_SIZE);
    return CGRectMake(origin.x, origin.y, dimensions.x, dimensions.y);
}

-(NSArray *)getSurroundingTilesAtPosition:(CGPoint)position forLayer:(CCTMXLayer *)layer initValue:(int)tileInit
{

    CGPoint plPos = [self tileCoordForPosition:position];
    
    NSMutableArray *gids = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        int c = i % 3;
        int r = (int)(i / 3);
        CGPoint tilePos = ccp(plPos.x + (c - 1), plPos.y + (r - 1));
        
        int tgid = tileInit;
        if (tilePos.x >= 0 && tilePos.x < map.mapSize.width && tilePos.y >= 0 && tilePos.y < map.mapSize.height) {
            tgid = [layer tileGIDAt:tilePos];
        }
                
        NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:tgid], @"gid",
                                  [NSValue valueWithCGPoint:tilePos],@"tilePos",
                                  nil];
        [gids addObject:tileDict];
        
    }
    
    [gids insertObject:[gids objectAtIndex:4] atIndex:9];
    [gids removeObjectAtIndex:4];
    [gids insertObject:[gids objectAtIndex:2] atIndex:6];
    [gids removeObjectAtIndex:2];
    [gids exchangeObjectAtIndex:4 withObjectAtIndex:6];
    [gids exchangeObjectAtIndex:0 withObjectAtIndex:4];
    
    return (NSArray *)gids;
}

-(void)checkForAndResolveCollisions:(CCSprite<wallCollision> *)p withBox:(BOOL)isBox
{
    
    int tileInit = isBox ? 1 : 0;
    NSArray *tiles = [self getSurroundingTilesAtPosition:p.position forLayer:walls initValue:tileInit];
    
    p.onGround = NO;
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [p collisionBoundingBox];
        int gid = [[dic objectForKey:@"gid"] intValue];
        if (gid) {
            CGRect tileRect = [self tileRectFromTileCoords:[[dic objectForKey:@"tilePos"] CGPointValue]];
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                int tileIndx = [tiles indexOfObject:dic];
                int x, y;
                switch (tileIndx) {
                    case 0:
                        //tile is directly below player
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                        p.velocity = ccp(p.velocity.x, 0.0);
                        p.onGround = YES;
                        break;
                    case 1:
                        //tile is directly above player
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                        p.velocity = ccp(p.velocity.x, 0.0);
                        break;
                    case 2:
                        //tile is left of player
                        p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                        break;
                    case 3:
                        //tile is right of player
                        p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                        break;
                    case 8:
                        //Tile in the middle of the object
                        x = ((p.desiredPosition.x - p.position.x) >= 0) ? 1 : -1;;
                        x = p.desiredPosition.x - x * intersection.size.width;
                        x = ((p.desiredPosition.y - p.position.y) >= 0) ? 1 : -1;;
                        x = p.desiredPosition.y - y * intersection.size.height;
                        p.desiredPosition = ccp(x, y);
                        break;
                    default:
                        if (intersection.size.width > intersection.size.height) {
                            //tile is diagonal, but resolving collision vertially
                            p.velocity = ccp(p.velocity.x, 0.0);
                            float resolutionHeight;
                            if (tileIndx > 5) {
                                resolutionHeight = intersection.size.height;
                                p.onGround = YES;
                            } else {
                                resolutionHeight = -intersection.size.height;
                            }
                            p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight);
                        } else {
                            float resolutionWidth;
                            if (tileIndx == 6 || tileIndx == 4) {
                                resolutionWidth = intersection.size.width;
                            } else {
                                resolutionWidth = -intersection.size.width;
                            }
                            p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y);
                        } 
                        break;
                }
            }
        } 
    }
    p.position = p.desiredPosition;
}

-(NSArray *)bulletWallsCollisions:(NSArray *)bullets
{
    NSMutableArray *toRemove = [NSMutableArray array];    
    for (CCSprite *b in bullets) {
        NSArray *tiles = [self getSurroundingTilesAtPosition:b.position forLayer:walls initValue:0];
        for (NSDictionary *dic in tiles) {
            CGRect bRect = CGRectInset(b.boundingBox, 2, 2);
            int gid = [[dic objectForKey:@"gid"] intValue];
            if (gid) {
                CGRect tileRect = [self tileRectFromTileCoords:[[dic objectForKey:@"tilePos"] CGPointValue]];
                if (CGRectIntersectsRect(bRect, tileRect)) {
                    [toRemove addObject:b];
                    break;
                }
            }
        }
    }
    return toRemove;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_pause)
        return;

    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    [player fireAt:location inLayer:self];
}

-(void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    if (sprite.tag == 1) { // monster
        [_monsters removeObject:sprite];
    } else if (sprite.tag == 2) { // projectile
        [_projectiles removeObject:sprite];
    } else if (sprite.tag == 3) { // monster shoot
        [_monsterShoot removeObject:sprite];
    }
    [self removeChild:sprite cleanup:YES];
}

-(void)addTarget
{
    int level = player.lvl;
    
    int waveN = arc4random() % level;
    /* not always a wave */
    if (waveN <= 2+_prevWavN) {
        waveN = 0;
    } else if (waveN <= 8) {
        waveN = 1;
    } else {
        waveN = 2;
    }
    _prevWavN = waveN;
    for (int i = 0 ; i < waveN ; i ++) {
        int j = 0;
        NSArray *tmp = [Monster generateWave:level];
        player.monsterTot += [tmp count];
        for (Monster *target in tmp) {
            [target positionAndMoveInLayer:self withDelay:3*(float)(i+j)/(float)([tmp count]+waveN)];
            target.tag = 1;
            [_monsters addObject:target];
            j++;
        }
    }

    int monsterN = arc4random() % (level + 1);
    /* not always a monster */
    if (monsterN == 0) {
        return;
    } else if (monsterN <= 6) {
        monsterN = 1;
    } else {
        monsterN = 2;
    }
    monsterN -= waveN;
    for (int i = 0 ; i < monsterN ; i ++) {
        Monster *target = [Monster generateMonsterForLevel:level];
        [target positionAndMoveInLayer:self withDelay:(float)i/(float)monsterN];
        target.tag = 1;
        [_monsters addObject:target];
    }
    player.monsterTot += monsterN;
}

- (void)bulletMonsterCollision
{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        CGRect projectileRect = CGRectInset(projectile.boundingBox, 0, 0);
        BOOL monsterHit = FALSE;
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *target in _monsters) {
            CGRect targetRect = CGRectInset(target.boundingBox, 2, 2);
            
            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                monsterHit = TRUE;
                Monster *monster = (Monster *)target;
                monster.hp--;
                if (monster.hp <= 0)
                    [targetsToDelete addObject:target];
                [projectilesToDelete addObject:projectile];
                break;
            }
        }
        
        for (Monster *target in targetsToDelete) {
            player.monsterKilled += 1;
            [target youRDeadInLayer:self];
            [_monsters removeObject:target];
        }
        
        [targetsToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    player.ammoHit += [projectilesToDelete count];
    [projectilesToDelete release];
}

-(void)playerMonterCollision
{
    CGRect playerRect = CGRectInset(player.boundingBox, 2, 2);
    
    BOOL monsterHitPlayer = FALSE;
    NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *monster in _monsters) {
        CGRect monsterRect = CGRectInset(monster.boundingBox, 2, 2);
        
        if (CGRectIntersectsRect(playerRect, monsterRect)) {
            monsterHitPlayer = TRUE;
            player.hp = player.hp - HP_LOST_FOR_MONSTER_HIT;
            player.monsterHitted += 1;
            [monstersToDelete addObject:monster];
        }
    }
    
    for (CCSprite *monster in monstersToDelete) {
        [_monsters removeObject:monster];
        [self removeChild:monster cleanup:YES];
    }
    
    [monstersToDelete release];
}

-(void)playerMonsterAmmoCollision
{
    CGRect playerRect = CGRectInset(player.boundingBox, 2, 2);
    
    NSMutableArray *monstersAmmoToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *ammo in _monsterShoot) {
        CGRect monsterRect = CGRectInset(ammo.boundingBox, 2, 2);
        
        if (CGRectIntersectsRect(playerRect, monsterRect)) {
            player.hp = player.hp - HP_LOST_FOR_MONSTER_SHOOT;
            [monstersAmmoToDelete addObject:ammo];
        }
    }
    
    for (CCSprite *ammo in monstersAmmoToDelete) {
        [_monsterShoot removeObject:ammo];
        [self removeChild:ammo cleanup:YES];
    }
    
    [monstersAmmoToDelete release];
}

-(void)playerAmmoCollision
{
    CGRect playerRect = CGRectInset(player.boundingBox, 2, 0);
    
    NSMutableArray *ammoToDelete = [NSMutableArray array];
    for (CCSprite *a in _ammunitions) {
        CGRect ammoRect = CGRectInset(a.boundingBox, 0, 0);
        if (CGRectIntersectsRect(playerRect, ammoRect)) {
            [ammoToDelete addObject:a];
            player.hp += 1;
            player.ammoTaken += 1;
        }
    }
    
    for (CCSprite *a in ammoToDelete) {
        [_ammunitions removeObject:a];
        [self removeChild:a cleanup:YES];
    }
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (_pause)
        return;

    if(acceleration.y < -0.04 || (!player.onGround && acceleration.y < 0)) {  // tilting the device to the right
        player.velocity = ccp(-SPEED_OF_PLAYER, player.velocity.y);
    } else if (acceleration.y > 0.04 || (!player.onGround && acceleration.y > 0)) {  // tilting the device to the left
        player.velocity = ccp(SPEED_OF_PLAYER, player.velocity.y);
    }
    else {
        player.velocity = ccp(0, player.velocity.y);
    }
}

-(void)gameLogic:(ccTime)dt
{
    // update lvl
    player.time += 1;
    int lvl = player.points/(player.lvl*player.lvl*5) + 1;
    player.lvl = min(max(lvl, player.lvl), 10);
    // add tagets
    [self addTarget];
}

-(void)gameOver
{
    [player explodeInLayer:self];
    [map removeChild:player cleanup:YES];
    [self scheduleOnce:@selector(makeTransition) delay:1.5];
}

-(void)makeTransition
{
    if (player.ammoTot == 0)
        player.ammoTot = 1;
    if (player.monsterTot == 0)
        player.monsterTot = 1;
    if (player.ammoShot == 0)
        player.ammoShot = 1;
    float accuracy = (float)player.ammoHit / (float)player.ammoShot; //sniper
    float collected = (float)player.ammoTaken / (float)player.ammoTot; //collector
    float escaped = (float)player.monsterKilled / (float)player.monsterTot; //nemsis
    if (!escaped) {
        escaped = 0;
    }

    CCScene *sc = [GameResult sceneWithAccuracy:accuracy collected:collected escaped:escaped time:player.time lvl:player.lvl score:player.points];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:sc]];
}


@end