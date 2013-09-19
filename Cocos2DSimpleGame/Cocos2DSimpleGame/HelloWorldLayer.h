//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray * _monsters;
    NSMutableArray * _lifeUps;
    NSMutableArray * _projectiles;
    int _monstersDestroyed;
    int _monstersInLevel;
    float _lifeUpProbability;
    NSArray* _monstersPerLevel;
    CCLabelTTF * _enemyCountLabel;
    CCLabelTTF * _levelLabel;
    CCLabelTTF * _livesLabel;
    NSArray* _heartSprites;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
