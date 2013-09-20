//
//  InGameLayer.m
//  multipong
//
//  Created by Jorge Lorenzon on 12/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InGameLayer.h"
#import "GCpShapeCache.h"

@implementation InGameLayer

- (void) didLoadFromCCB {
    NSLog(@"loaded layer");
    
//    BOOL loadedShape = [[GCpShapeCache sharedShapeCache] addShapesWithFile:@"PaddlePhysics.plist"];
    
    spaceManager = [[SpaceManagerCocos2d alloc] init];
    
    [spaceManager addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
    
    [spaceManager setGravity:ccp(0, 0)];
    
    
    // create and add body to space
    cpBody *ballBody = cpBodyNew(1, 1);
    
    // set the center point
//    body->p = bd->anchorPoint;
    
    // set the data
//    body->data = data;
    
    // add space to body
    [spaceManager addBody:ballBody];
    
    cpShape* circleShape = cpCircleShapeNew(ballBody, 8, cpv(0, 0));
    
    [spaceManager addShape:circleShape];
    
    [(cpCCSprite*)ballSprite setShape:circleShape];
    
    [ballSprite setPosition:CGPointMake(160, 240)];
    
    ballBody->v = cpv(0, -30);
    
//    [spaceManager start];
    
    isServer = NO;
}

- (void) start:(GKMatch*)match {
    NSLog(@"start");
    
    _match = match;
    if ([(NSString*)[_match.playerIDs objectAtIndex:0] compare:[GKLocalPlayer localPlayer].playerID] == NSOrderedAscending) {
        isServer = YES;
        _match = match;
        [[CCDirector sharedDirector].scheduler scheduleSelector:@selector(sendData) forTarget:self interval:0.1f paused:NO];
    }
    
    [spaceManager start];
}

- (void) sendData {
    
    static long snapshotId = 1;
    
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    cpCCSprite* bs = (cpCCSprite*)ballSprite;
    
    [dataDict setObject:[NSNumber numberWithLong:snapshotId] forKey:@"SnapshotId"];    
    [dataDict setObject:[NSNumber numberWithFloat:bs.body->p.x] forKey:@"BallPosX"];
    [dataDict setObject:[NSNumber numberWithFloat:bs.body->p.y] forKey:@"BallPosY"];
    [dataDict setObject:[NSNumber numberWithFloat:bs.body->v.x] forKey:@"BallVelX"];
    [dataDict setObject:[NSNumber numberWithFloat:bs.body->v.y] forKey:@"BallVelY"];
    
    snapshotId++;
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
    
    NSError* error = nil;
    [_match sendData:data toPlayers:[_match playerIDs] withDataMode:GKMatchSendDataUnreliable error:&error];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    static long lastReceivedSnapshotId = 0;
    
    if (ballSprite != nil) {
        NSDictionary* dataDict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
        cpCCSprite* bs = (cpCCSprite*)ballSprite;
        if ([[dataDict objectForKey:@"SnapshotId"] longValue] > lastReceivedSnapshotId) {
            bs.body->p = cpv([[dataDict objectForKey:@"BallPosX"] floatValue], [[dataDict objectForKey:@"BallPosY"] floatValue]);
            bs.body->v = cpv([[dataDict objectForKey:@"BallVelX"] floatValue], [[dataDict objectForKey:@"BallVelY"] floatValue]);
            lastReceivedSnapshotId = [[dataDict objectForKey:@"SnapshotId"] longValue];
        } else {
            NSLog(@"discarded data");
        }
    }
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    NSLog(@"player %@ changed state %d", playerID, state);
    
    if (state == GKPlayerStateConnected) {
//        if ([playerID compare:[GKLocalPlayer localPlayer].playerID] == NSOrderedAscending) {
//            isServer = YES;
//            [[CCDirector sharedDirector].scheduler scheduleSelector:@selector(sendData) forTarget:self interval:0.1f paused:NO];
//            [spaceManager start];
//        }
    }
    
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
    NSLog(@"failed match");
}


@end
