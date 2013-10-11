//
//  LevelManager.m
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 9/12/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "LevelManager.h"

@implementation LevelManager

+ (LevelManager*)sharedManager {
    static LevelManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}	

- (id)init {
    if (self = [super init]) {
        _levelNum = 0;
        _lives = 3;
        _comboCounter = 0;
        _winSize = [CCDirector sharedDirector].winSize;
        
        CCParticleRain *rain = [[CCParticleRain alloc] initWithTotalParticles:500];
        rain.life += 1;
        rain.position = ccp(_winSize.width/2, _winSize.height);
        [rain setBlendAdditive:NO];
        
        CCParticleSnow *snow = [[CCParticleSnow alloc] initWithTotalParticles:500];
        [snow setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Snowflake-white.png"]];
        snow.position = ccp(_winSize.width/2, _winSize.height);
        [snow setBlendAdditive:NO];
        
        Level * level1 = [[Level alloc] initWithLevelNum:1 enemiesNum:5 secsPerSpawn:2 backgroundColor:ccc4(255, 255, 255, 255) particleSystem:rain];
        Level * level2 = [[Level alloc] initWithLevelNum:2 enemiesNum:10 secsPerSpawn:1 backgroundColor:ccc4(100, 150, 20, 255) particleSystem:nil];
        Level * level3 = [[Level alloc] initWithLevelNum:3 enemiesNum:15 secsPerSpawn:0.5 backgroundColor:ccc4(20, 150, 100, 255) particleSystem:nil];
        Level * level4 = [[Level alloc] initWithLevelNum:4 enemiesNum:20 secsPerSpawn:0.5 backgroundColor:ccc4(176, 23, 31, 255) particleSystem:nil];      //indian red
        Level * level5 = [[Level alloc] initWithLevelNum:5 enemiesNum:25 secsPerSpawn:0.5 backgroundColor:ccc4(255, 20, 147, 255) particleSystem:nil];     //deeppink 1 (deeppink)
        Level * level6 = [[Level alloc] initWithLevelNum:6 enemiesNum:25 secsPerSpawn:0.4 backgroundColor:ccc4(148, 0, 211, 255) particleSystem:nil];       //darkviolet
        Level * level7 = [[Level alloc] initWithLevelNum:7 enemiesNum:30 secsPerSpawn:0.4 backgroundColor:ccc4(202, 225, 255, 255) particleSystem:snow];    //royalblue
        Level * level8 = [[Level alloc] initWithLevelNum:8 enemiesNum:30 secsPerSpawn:0.3 backgroundColor:ccc4(0, 255, 255, 255) particleSystem:nil];       //cyan
        Level * level9 = [[Level alloc] initWithLevelNum:9 enemiesNum:30 secsPerSpawn:0.2 backgroundColor:ccc4(0, 255, 0, 255) particleSystem:nil];         //green
        Level * level10 = [[Level alloc] initWithLevelNum:10 enemiesNum:40 secsPerSpawn:0.2 backgroundColor:ccc4(150, 150, 150, 255) particleSystem:nil];    //gray
        _levels = @[level1, level2, level3, level4, level5, level6, level7, level8, level9, level10];
    }
    return self;
}

- (Level *)curLevel {
    if (_levelNum >= _levels.count) {
        return nil;
    }
    return _levels[_levelNum];
}

- (void)reset {
    _levelNum = 0;
    _lives = 3;
    _comboCounter = 0;
}

@end
