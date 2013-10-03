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
    }
    return self;
}


@end
