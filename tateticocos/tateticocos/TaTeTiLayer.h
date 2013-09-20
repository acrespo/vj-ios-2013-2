//
//  TaTeTiLayer.h
//  tateticocos
//
//  Created by Jorge Lorenzon on 10/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelHelperLoader.h"

@interface TaTeTiLayer : CCLayerColor {
    CCSprite* celdas;
}

@property (strong, nonatomic) LevelHelperLoader* loader;

+(CCScene *) scene;

@end
