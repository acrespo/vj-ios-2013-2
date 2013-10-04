//
//  LevelManager.h
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 9/12/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

@property int levelNum;
@property NSArray * levels;
@property int lives;
@property int comboCounter;
@property (nonatomic) Level* curLevel;

+ (LevelManager*)sharedManager;
- (Level *)curLevel;
- (void)reset;
@end
