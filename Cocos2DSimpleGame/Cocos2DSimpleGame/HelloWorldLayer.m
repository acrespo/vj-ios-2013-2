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
    
    CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_monsters removeObject:node];
        [node removeFromParentAndCleanup:YES];
        
        _lives--;
        if (_lives < 0) {
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
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

- (void) addLifeBonus {

    CCSprite * lifeUp = [CCSprite spriteWithFile:@"heart.png"];
    
    // Determine where to spawn the lifeup along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
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
    float random = arc4random_uniform(100)/100.0;
    if (random < _lifeUpProbability) {
        [self addLifeBonus];
    }
}
 
- (id) init
{
    if ((self = [super initWithColor:ccc4(255,255,255,255)])) {

        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
        [self addChild:player];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
        
        [self setTouchEnabled:YES];
        
         _monstersPerLevel = [NSArray arrayWithObjects:@(10), @(20), @(30), nil];
        
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        _lifeUps = [[NSMutableArray alloc] init];
        
        _lifeUpProbability = 0.1;
        _comboCounter = [LevelManager sharedManager].comboCounter;
        _lives = [LevelManager sharedManager].lives;
        _level = [LevelManager sharedManager].level;
        _monstersInLevel = [_monstersPerLevel[_level] intValue];

        NSString* enemyCountMessage = [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel];
        _enemyCountLabel = [CCLabelTTF labelWithString:enemyCountMessage fontName:@"Arial" fontSize:28];
        _enemyCountLabel.color = ccc3(0,0,0);
        _enemyCountLabel.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_enemyCountLabel];
        
        NSString* levelMessage = [NSString stringWithFormat: @"Level %d", _level];
        _levelLabel = [CCLabelTTF labelWithString:levelMessage fontName:@"Arial" fontSize:28];
        _levelLabel.color = ccc3(0,0,0);
        _levelLabel.position = ccp(winSize.width - _levelLabel.contentSize.width, winSize.height - _levelLabel.contentSize.height/2);
        [self addChild:_levelLabel];
        
        NSString* livesMessage = [NSString stringWithFormat: @"Lives %d", _level];
        _livesLabel = [CCLabelTTF labelWithString:livesMessage fontName:@"Arial" fontSize:28];
        _livesLabel.color = ccc3(0,0,0);
        _livesLabel.position = ccp(winSize.width/2 + _livesLabel.contentSize.width/2, winSize.height - _livesLabel.contentSize.height/2);
        [self addChild:_livesLabel];
        
        
        // Standard method to create a button
        _starMenuItem = [CCMenuItemImage
                                    itemWithNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                    target:self selector:@selector(pauseButtonTapped:)];
        _starMenuItem.position = ccp(winSize.width-_starMenuItem.contentSize.width/2, _starMenuItem.contentSize.height/2);
        CCMenu *starMenu = [CCMenu menuWithItems:_starMenuItem, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        NSString* pauseMenuMessage = [NSString stringWithFormat: @"Pause"];
        _pauseLabel = [CCLabelTTF labelWithString:pauseMenuMessage fontName:@"Arial" fontSize:28];
        _pauseLabel.color = ccc3(0,0,0);
        _pauseLabel.position = ccp(winSize.width - _starMenuItem.contentSize.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2);
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
        
    }
    return self;
}

- (void)unpauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Pause"];
    [CCDirector sharedDirector].scheduler.timeScale = 1;
    [_starMenuItem setTarget:self selector:@selector(pauseButtonTapped:)];
}


- (void)pauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Resume"];
    [CCDirector sharedDirector].scheduler.timeScale = 0;
    [_starMenuItem setTarget:self selector:@selector(unpauseButtonTapped:)];

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"
                                               rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [_projectiles removeObject:node];
         _comboCounter = 0;
         [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];
         [node removeFromParentAndCleanup:YES];
    }],
      nil]];
    
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                [monstersToDelete addObject:monster];
            }
        }
                
        for (CCSprite *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
            
            _monstersDestroyed++;
            [_enemyCountLabel setString: [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel]];
            _comboCounter++;
            [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];
            if (_monstersDestroyed >= _monstersInLevel) {
                int level = ++_level;
                if (level >= 3) {
                    _level = 0;
                }
                
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
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
        
        
        if (monstersToDelete.count > 0 || livesToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
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
