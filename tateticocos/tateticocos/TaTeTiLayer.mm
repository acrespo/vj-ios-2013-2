//
//  TaTeTiLayer.m
//  tateticocos
//
//  Created by Jorge Lorenzon on 10/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TaTeTiLayer.h"
#import "LevelHelperLoader.h"


@implementation TaTeTiLayer
@synthesize loader = _loader;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TaTeTiLayer *layer = [TaTeTiLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		
        self.isTouchEnabled = YES;
        
        celdas = [[CCSprite alloc] initWithFile:@"TatetiCeldas.png"];
        celdas.position = ccp(160, 240);
        //celdas.anchorPointInPoints = CGPointMake(160, 160);
        
        [self addChild:celdas];
        
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
    NSLog(@"register");
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [celdas convertTouchToNodeSpaceAR:touch];
        
    NSLog(@"Touch BEGIN in point (%f; %f)", touchPoint.x, touchPoint.y);            
    
    int column = 2;
    if (touchPoint.x < -52)
    column = 0;
    else if (touchPoint.x < 52)
    column = 1;
    
    int row = 2;    
    if (touchPoint.y > 50)
    row = 0;
    else if (touchPoint.y > -60)
    row = 1;
    
    NSLog(@"Cell %d, %d", row, column);
    
    CCSprite* circle = [[CCSprite alloc] initWithFile:@"Circle.png"];
    
    [self addChild:circle];
    circle.position = [self convertTouchToNodeSpace:touch];
    
    return YES;
}


//-(void)touchBegin:(LHTouchInfo*)info{
//    CGPoint relativePoint = info.relativePoint;
//    NSLog(@"Touch BEGIN on sprite %@ in point (%f; %f)", [info.sprite uniqueName], relativePoint.x, relativePoint.y);            
//    
//    int column = 2;
//    if (relativePoint.x < -52)
//        column = 0;
//    else if (relativePoint.x < 52)
//        column = 1;
//    
//    int row = 2;    
//    if (relativePoint.y > 50)
//        row = 0;
//    else if (relativePoint.y > -60)
//        row = 1;
//    
//    NSLog(@"Cell %d, %d", row, column);
//    
//    LHSprite* circleSprite = [_loader createSpriteWithName:@"Circle" fromSheet:@"TaTeTi" fromSHFile:@"TaTeTiAtlas"];
//    
//    circleSprite.position = [info.sprite convertToWorldSpaceAR:relativePoint];
//}   

@end
