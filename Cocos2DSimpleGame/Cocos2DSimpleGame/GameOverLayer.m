//
//  GameOverLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright 2012 Razeware LLC. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "LevelManager.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won caller:(CCLayerColor*)callerLayer {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won caller:callerLayer];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won caller:(CCLayerColor*) callerLayer {
    
 
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)]) && [callerLayer isMemberOfClass:[HelloWorldLayer class]]) {
        
        _callerLayer = callerLayer;
        NSString * message;
        if (won) {
            message = @"You Won!";
            [LevelManager sharedManager].level = ((HelloWorldLayer*)_callerLayer).level;
            [LevelManager sharedManager].lives = ((HelloWorldLayer*)_callerLayer).lives;
            [LevelManager sharedManager].comboCounter = ((HelloWorldLayer*)_callerLayer).comboCounter;
        } else {
            message = @"You Lose :[";
            [LevelManager sharedManager].level = 0;
            [LevelManager sharedManager].lives = 3;
            [LevelManager sharedManager].comboCounter = 0;
        }

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }],
          nil]];
    }
    return self;
}

@end
