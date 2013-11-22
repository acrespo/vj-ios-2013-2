//
//  HelloWorldLayer.h
//  Tale
//
//  Created by AdminMacLC04 on 10/24/13.
//  Copyright AdminMacLC04 2013. All rights reserved.
//

#import "cocos2d.h"
#import "Graph.h"
#import "HudLayer.h"
#import "ObjectiveChipmunk.h"

@class Player;

@interface GameLayer : CCLayerColor {

    CCTMXLayer *_background;
    CCTMXLayer *_meta;
    CCTMXLayer *_foreground;
    
    Graph* _graph;
    
    NSMutableArray *_enemies;
    CCSpriteBatchNode *_enemyBatch;

    HudLayer *_hud;
    int _numCollected;

    BOOL _mouseDown;
    CGPoint _mousePos;
}

@property float time;
@property (strong) CCTMXTiledMap *tileMap;
@property (nonatomic, strong) ChipmunkSpace *space;
@property (nonatomic, strong) Player *player;

+ (CCScene *)scene;

- (CGPoint)tileCoordForPosition:(CGPoint)position;

- (void)setPlayerPosition:(CGPoint) position;
- (void)setViewPointCenter:(CGPoint) position;

-(NSMutableArray*) findPathFrom:(CGPoint)fromPos to:(CGPoint)toPos;
@end
