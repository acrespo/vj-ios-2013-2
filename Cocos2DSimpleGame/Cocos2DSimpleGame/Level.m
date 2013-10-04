//
//  Level.m
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 10/3/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum enemiesNum:(int)enemiesNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor {
    if ((self = [super init])) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundColor = backgroundColor;
        self.enemiesNum = enemiesNum;
    }
    return self;
}

@end