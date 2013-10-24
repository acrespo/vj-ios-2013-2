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
#import "Level.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray * _monsters;
    NSMutableArray * _lifeUps;
    NSMutableArray * _projectiles;
    NSArray* _heartSprites;
    int _monstersDestroyed;
    int _monstersInLevel;
    float _lifeUpProbability;
    CCLabelTTF * _enemyCountLabel;
    CCLabelTTF * _levelLabel;
    CCLabelTTF * _livesLabel;
    CCLabelTTF * _comboLabel;
    CCLabelTTF * _pauseLabel;
    CCMenuItem * _starMenuItem;
    CCMenuItem * _nextLevelMenuItem;
    CGSize winSize;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    int _backgroundMusicVolume;
    CCAnimation * _walkAnim;
    CCSpriteBatchNode * _spriteSheet;
    bool _touching;
    NSSet* _lastTouches;
    float _reloadTime;
    float _reloadCount;

}
@property Level* level;
@property int lives;
@property int comboCounter;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) monsterBreach:(CCNode*)node;
@end
