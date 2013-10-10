//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"
#import "LevelManager.h"
#import "Monster.h"
#import "Level.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

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

- (void) addMonster {
    
    //CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    Monster* monster = [self createMonster];

    // Determine where to spawn the monster along the Y axis
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = monster.minMoveDuration; //2.0;
    int maxDuration = monster.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_monsters removeObject:node];
        [node removeFromParentAndCleanup:YES];
        
        _lives--;
        if (_lives < 0) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO caller:self];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        } else {
            [_heartSprites[_lives] setTexture:[[CCSprite spriteWithFile:@"heartempty.png"] texture]];
            [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
        }
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    monster.tag = 1;
    [_monsters addObject:monster];
    
}

- (Monster*) createMonster {
    Monster * monster = nil;
    if (arc4random() % 10 < 5) {
        monster = [[WeakAndFastMonster alloc] init];
    } else if (arc4random() % 10 < 8) {
        monster = [[StrongAndSlowMonster alloc] init];
    } else if (arc4random() % 10 < 10) {
        monster = [[StrongAndStupidMonster alloc] init];
    }
    return monster;
}


- (void) addLifeBonus {

    CCSprite * lifeUp = [CCSprite spriteWithFile:@"heart.png"];
    
    // Determine where to spawn the lifeup along the Y axis
    int minY = lifeUp.contentSize.height / 2;
    int maxY = winSize.height - lifeUp.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the lifeup sprite slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    lifeUp.position = ccp(winSize.width + lifeUp.contentSize.width/2, actualY);
    [self addChild:lifeUp];
    
    // Determine speed of the life bonus
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-lifeUp.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_lifeUps removeObject:node];
        [node removeFromParentAndCleanup:YES];
    }];
    [lifeUp runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    lifeUp.tag = 2;
    [_lifeUps addObject:lifeUp];
    
}

-(void)gameLogic:(ccTime)dt {
    [self addMonster];
    float secsPerSpawn = [LevelManager sharedManager].curLevel.secsPerSpawn;
    float random = arc4random_uniform(100*secsPerSpawn)/(100.0*secsPerSpawn);
    if (random < _lifeUpProbability) {
        [self addLifeBonus];
    }
}
 
- (id) init
{
    if ((self = [super initWithColor:[LevelManager sharedManager].curLevel.backgroundColor])) {

        winSize = [CCDirector sharedDirector].winSize;
        _player = [CCSprite spriteWithFile:@"player.png"];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
        
        [self schedule:@selector(gameLogic:) interval:[LevelManager sharedManager].curLevel.secsPerSpawn];
        
        [self setTouchEnabled:YES];
                
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        _lifeUps = [[NSMutableArray alloc] init];
        
        _lifeUpProbability = 0.1;
        _comboCounter = [LevelManager sharedManager].comboCounter;
        _lives = [LevelManager sharedManager].lives;
        _level = [[LevelManager sharedManager] curLevel];
        _monstersInLevel = _level.enemiesNum;

        NSString* enemyCountMessage = [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel];
        _enemyCountLabel = [CCLabelTTF labelWithString:enemyCountMessage fontName:@"Arial" fontSize:28];
        _enemyCountLabel.color = ccc3(0,0,0);
        _enemyCountLabel.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_enemyCountLabel];
        
        NSString* levelMessage = [NSString stringWithFormat: @"Level %d", _level.levelNum];
        _levelLabel = [CCLabelTTF labelWithString:levelMessage fontName:@"Arial" fontSize:28];
        _levelLabel.color = ccc3(0,0,0);
        _levelLabel.position = ccp(winSize.width - _levelLabel.contentSize.width, winSize.height - _levelLabel.contentSize.height/2);
        [self addChild:_levelLabel];
        
        NSString* livesMessage = [NSString stringWithFormat: @"Lives %d", _level.levelNum];
        _livesLabel = [CCLabelTTF labelWithString:livesMessage fontName:@"Arial" fontSize:28];
        _livesLabel.color = ccc3(0,0,0);
        _livesLabel.position = ccp(winSize.width/2 + _livesLabel.contentSize.width/2, winSize.height - _livesLabel.contentSize.height/2);
        [self addChild:_livesLabel];
        
        
        // Standard method to create a button
        _starMenuItem = [CCMenuItemImage
                                    itemWithNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                    target:self selector:@selector(pauseButtonTapped:)];
        _starMenuItem.scale = 0.5;
        _starMenuItem.position = ccp(winSize.width-_starMenuItem.boundingBox.size.width/2, _starMenuItem.boundingBox.size.height/2);
        CCMenu *starMenu = [CCMenu menuWithItems:_starMenuItem, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        NSString* pauseMenuMessage = [NSString stringWithFormat: @"Pause"];
        _pauseLabel = [CCLabelTTF labelWithString:pauseMenuMessage fontName:@"Arial" fontSize:28];
        _pauseLabel.color = ccc3(0,0,0);
        _pauseLabel.position = ccp(winSize.width - _starMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2);
        [self addChild:_pauseLabel];
        

        

        NSString* comboMessage = [NSString stringWithFormat: @"Combo: x%d", _comboCounter];
        _comboLabel = [CCLabelTTF labelWithString:comboMessage fontName:@"Arial" fontSize:12];
        _comboLabel.color = ccc3(0,0,0);
        _comboLabel.position = ccp(winSize.width/2 + _comboLabel.contentSize.width, winSize.height - _comboLabel.contentSize.height*2);
        [self addChild:_comboLabel];
        
        _heartSprites = [NSArray arrayWithObjects:[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"], nil];
        int i = 1;
        for (CCSprite* heartSprite in _heartSprites) {
            if (i - 1 >= _lives) {
                [heartSprite setTexture:[[CCSprite spriteWithFile:@"heartempty.png"] texture]];
            }
            heartSprite.position = ccp(winSize.width/2  - heartSprite.contentSize.width*i++, winSize.height - heartSprite.contentSize.height/2);
            [self addChild:heartSprite];
        }
        
        [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
        
        [self schedule:@selector(update:)];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        _backgroundMusicVolume = [SimpleAudioEngine sharedEngine].backgroundMusicVolume;
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = _backgroundMusicVolume/5.0;
        
    }
    return self;
}

- (void)unpauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Pause"];
    [_pauseLabel setPosition:ccp(winSize.width - _starMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2)];
    [CCDirector sharedDirector].scheduler.timeScale = 1;
    [_starMenuItem setTarget:self selector:@selector(pauseButtonTapped:)];
}


- (void)pauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Resume"];
    [_pauseLabel setPosition:ccp(winSize.width - _starMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2)];
    [CCDirector sharedDirector].scheduler.timeScale = 0;
    [_starMenuItem setTarget:self selector:@selector(unpauseButtonTapped:)];

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_nextProjectile != nil) return;
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    _nextProjectile = [CCSprite spriteWithFile:@"projectile.png" rect:CGRectMake(0, 0, 20, 20)];
    _nextProjectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, _nextProjectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + _nextProjectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - _nextProjectile.position.x;
    int offRealY = realY - _nextProjectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Determine angle to face
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    float rotateDegreesPerSecond = 180 / 0.3; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
    float degreesDiff = _player.rotation - cocosAngle;
    float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
    [_player runAction:
     [CCSequence actions:
      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
      [CCCallBlock actionWithBlock:^{
         // OK to add now - rotation is finished!
         [self addChild:_nextProjectile];
         [_projectiles addObject:_nextProjectile];
         // Release
         _nextProjectile = nil;
     }],
      nil]];
    
    // Move projectile to actual endpoint
    [_nextProjectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [_projectiles removeObject:node];
         _comboCounter = 0;
         [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];
         [node removeFromParentAndCleanup:YES];
    }],
      nil]];
    
    _nextProjectile.tag = 2;
    [_projectiles addObject:_nextProjectile];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        BOOL monsterHit = FALSE;
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (Monster *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                monsterHit = TRUE;
                monster.hp--;
                if (monster.hp <= 0) {
                    [monstersToDelete addObject:monster];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"3b0817_New_Super_Mario_Bros_Firework_Sound_Effect.mp3"];
                }
                break;
            }
        }
                
        for (Monster *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
            
            _monstersDestroyed++;
            [_enemyCountLabel setString: [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel]];
            _comboCounter++;
            [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];

            if (_monstersDestroyed >= _monstersInLevel) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES caller:self];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        
        NSMutableArray *livesToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *life in _lifeUps) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, life.boundingBox)) {
                [livesToDelete addObject:life];
            }
        }
        
        for (CCSprite *life in livesToDelete) {
            [_lifeUps removeObject:life];
            [self removeChild:life cleanup:YES];
            if (_lives < 3) {
                [_heartSprites[_lives] setTexture:[[CCSprite spriteWithFile:@"heart.png"] texture]];
                _lives++;
                [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
                
            }
        }
        
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
        } else if (livesToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"3fc83f_Super_Mario_Bros_1_Up_Sound_Effect.mp3"];
        }
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    _monsters = nil;
    _projectiles = nil;
    _lifeUps = nil;
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
