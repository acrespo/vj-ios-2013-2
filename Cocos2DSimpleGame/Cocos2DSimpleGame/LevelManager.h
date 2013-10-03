//
//  LevelManager.h
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 9/12/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelManager : NSObject

@property int level;
@property int lives;
@property int comboCounter;

+ (LevelManager*)sharedManager;

@end
