//
//  InGameLayer.h
//  multipong
//
//  Created by Jorge Lorenzon on 12/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cpCCSprite.h"
#import "SpaceManagerCocos2d.h"
#import <GameKit/GameKit.h>

@interface InGameLayer : CCLayer <GKMatchDelegate>  {
    
    SpaceManagerCocos2d* spaceManager;
    
    CCSprite* ballSprite;
    
    BOOL isServer;
    
    GKMatch* _match;
}

- (void) start:(GKMatch*)match;

@end
