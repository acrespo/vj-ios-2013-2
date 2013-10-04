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
        _level = 0;
        _lives = 3;
        _comboCounter = 0;
        Level * level1 = [[Level alloc] initWithLevelNum:1 enemiesNum:5 secsPerSpawn:2 backgroundColor:ccc4(255, 255, 255, 255)];
        Level * level2 = [[Level alloc] initWithLevelNum:2 enemiesNum:10 secsPerSpawn:1 backgroundColor:ccc4(100, 150, 20, 255)];
        Level * level3 = [[Level alloc] initWithLevelNum:3 enemiesNum:15 secsPerSpawn:0.5 backgroundColor:ccc4(20, 150, 100, 255)];
        _levels = @[level1, level2, level3];
    }
    return self;
}

- (Level *)curLevel {
    if (_level >= _levels.count) {
        return nil;
    }
    return _levels[_level];
}

- (void)reset {
    _level = 0;
    _lives = 3;
    _comboCounter = 0;
}

@end
