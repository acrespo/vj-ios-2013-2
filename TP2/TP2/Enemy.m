//
//  Enemy.m
//  TP2
//
//  Created by AdminMacLC02 on 11/21/13.
//  Copyright (c) 2013 bb. All rights reserved.
//

#import "Enemy.h"
#import "Player.h"

#define FRICTION 0.67f
@implementation Enemy


- (id)initWithLayer:(GameLayer *)layer {
    self = [super initWithFile:@"enemy1.png"];
    
    if (self != nil) {
        _gameLayer = layer;
        _speed = 1770;
        float enemyMass = 10.0f;
        float enemyRadius = 13.0f;
        
        self.chipmunkBody = [layer.space add:[ChipmunkBody bodyWithMass:enemyMass andMoment:INFINITY]];
        ChipmunkShape *enemyShape = [layer.space add:[ChipmunkCircleShape circleWithBody:self.chipmunkBody radius:enemyRadius offset:cpvzero]];
        enemyShape.friction = 0.1;
    }
    [self schedule:@selector(update:)];
    
    return self;
}


- (void)update:(ccTime)delta {
    [self.chipmunkBody resetForces];

    if (_path != nil) {
        
        Node*  nextTile = [_path objectAtIndex:0];
        
        //        CCLOG(@"(%f,%f) - (%d,%d)", playerTile.x, playerTile.y, nextTile.x, nextTile.y);
        
        float x = (nextTile.x +0.5) * _gameLayer.tileMap.tileSize.width;
        float y  = (nextTile.y +0.5) * _gameLayer.tileMap.tileSize.height;
        
        CGPoint sub = ccpSub(ccp(x,y), self.position);
        if (ccpLengthSQ(sub) > 0) {
            CGPoint dir = ccpNormalize(sub);
            //            self.position = ccpAdd(ccpMult(dir, _speed*delta), self.position);
            [self.chipmunkBody applyForce:ccpMult(dir, _speed * self.chipmunkBody.mass) offset:cpvzero];
        }
        
        if (ccpFuzzyEqual(self.position, ccp(x,y), 20)) {
            if ([_path count] > 0) {
                [_path removeObjectAtIndex:0];
                if ([_path count] == 0) {
                    _path = nil;
                }
            }
        }
    } else {
        _path = [_gameLayer findPathFrom:self.position to:_gameLayer.player.position];
    }
    
    self.chipmunkBody.vel = ccpMult(self.chipmunkBody.vel, FRICTION);

}
@end
